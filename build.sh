#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
#
# Build the recovery image in a container.
#
#   ./build.sh --kernel Image.gz --dtb board.dtb [--recovery DIR] [--jobs N]
#   ./build.sh --shell                    a shell in the build tree
#
# The TWRP 12.1 source tree (~30 GB) lives in the Docker volume $VOLUME; the first
# run syncs it. The recovery fork (--recovery, default ../android_bootable_recovery)
# and this device tree are mounted from local clones, so local changes build without
# a push. The kernel is the GlassineOS/linux recovery kernel, built elsewhere.
#
# Output: out/recovery.img and out/recovery.img.sha256
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
IMAGE=glassine-twrp-builder:12.1
VOLUME=${VOLUME:-glassine-twrp-12.1}
MANIFEST_URL=https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git
MANIFEST_BRANCH=twrp-12.1

usage() { sed -n '4,6p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

kernel= dtb= recovery=$HERE/../android_bootable_recovery jobs=$(nproc) shell=
while [ $# -gt 0 ]; do
    case $1 in
        --kernel) kernel=$2; shift 2 ;;
        --dtb) dtb=$2; shift 2 ;;
        --recovery) recovery=$2; shift 2 ;;
        --jobs) jobs=$2; shift 2 ;;
        --shell) shell=1; shift ;;
        *) usage ;;
    esac
done
[ -d "$recovery/minui" ] || { echo "build.sh: no recovery source at $recovery" >&2; exit 1; }
recovery=$(cd "$recovery" && pwd)
if [ -z "$shell" ]; then
    [ -f "$kernel" ] && [ -f "$dtb" ] || usage
    mkdir -p "$HERE/prebuilt" "$HERE/out"
    cat "$kernel" "$dtb" > "$HERE/prebuilt/Image.gz-dtb"
fi

docker build -q -t "$IMAGE" "$HERE/docker" >/dev/null

sync_tree='
    if [ ! -d .repo ]; then
        repo init -q --depth=1 -u '"$MANIFEST_URL"' -b '"$MANIFEST_BRANCH"'
    fi
    mkdir -p .repo/local_manifests
    cp /device/manifest/local.xml .repo/local_manifests/glassine.xml
    repo sync -q -c -j8 --no-tags --no-clone-bundle --optimized-fetch --force-sync
'
build='
    . build/envsetup.sh
    lunch twrp_noteair-eng
    mka -j'"$jobs"' recoveryimage
    cp out/target/product/noteair/recovery.img /out/recovery.img
    chown '"$(id -u):$(id -g)"' /out/recovery.img
'

# the two local clones are mounted straight into the tree (the sync leaves both paths alone)
run=(docker run --rm -v "$VOLUME:/src"
     -v "$HERE:/src/device/onyx/noteair:ro" -v "$HERE:/device:ro"
     -v "$recovery:/src/bootable/recovery:ro" -v "$HERE/out:/out")
if [ -n "$shell" ]; then
    exec "${run[@]}" -it "$IMAGE" bash -c "$sync_tree exec bash"
fi
"${run[@]}" "$IMAGE" bash -ec "$sync_tree $build"
(cd "$HERE/out" && sha256sum recovery.img > recovery.img.sha256 && cat recovery.img.sha256)
