# GlassineOS/android_device_onyx_noteair

TWRP device tree for the Onyx Boox Note Air (SDM636), running on the GlassineOS
mainline recovery kernel. The recovery lives in the `recovery` partition; GlassineOS
itself boots from ABL slot B, stock Android stays in slot A.

**Status: skeleton.** The tree builds the recovery image layout; display, input and the
GlassineOS recovery actions are still to come.

## Pieces

| Repository | What |
|---|---|
| [android_bootable_recovery](https://github.com/GlassineOS/android_bootable_recovery) (branch `glassine/twrp-12.1`) | TWRP, with the GlassineOS changes as commits on top |
| this repository | board configuration, partition table, build script |
| [linux](https://github.com/GlassineOS/linux) | the recovery kernel: a minimal, module-free configuration of the GlassineOS kernel |
| [boot](https://github.com/GlassineOS/boot) | `glassine-deploy`: deployments, rollback, reset. TWRP calls it and never mounts `system_b` itself |

## Build

Needs Docker and about 40 GB of disk (the TWRP source tree lives in a Docker volume).

```sh
git clone git@github.com:GlassineOS/android_bootable_recovery.git
git clone git@github.com:GlassineOS/android_device_onyx_noteair.git
cd android_device_onyx_noteair
./build.sh --kernel Image.gz --dtb sdm636-onyx-noteair.dtb
```

The first run syncs the TWRP 12.1 tree. Both clones are mounted into it, so local
changes build without a push. The result is `out/recovery.img` with its sha256.

## Flash

By hand for now. `fastboot flash` does not work on this device; write the image to the
`recovery` partition with EDL or with `dd` from a running system.

## License

Apache-2.0, as is usual for device trees (see `LICENSE`). TWRP itself is
GPL-3.0-or-later with Apache-2.0 parts from AOSP; the kernel is GPL-2.0.
