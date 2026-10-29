# CLAUDE.md — GlassineOS/android_device_onyx_noteair

TWRP device tree for the Note Air (see `README.md`). Build with `./build.sh`.

- Nothing vendor-owned here: no Onyx kernel, firmware, blobs, dumps, keys, serials.
  The kernel comes from GlassineOS/linux at build time; `prebuilt/` and `out/` stay
  untracked.
- TWRP never mounts `system_b` itself and offers no wipe for it: `glassine-deploy`
  (GlassineOS/boot) owns those mounts (hibernate rule). Read paths from
  `glassine-deploy status --porcelain`, never hardcode them.
- Recovery behaviour goes into GlassineOS/android_bootable_recovery as commits, not as
  patch scripts in this tree.
- Commits carry an `Assisted-by:` or `Co-Authored-By:` trailer. Never add
  `Signed-off-by`. Run `.glassine/org/scripts/safety-scan.sh --staged` before committing.
