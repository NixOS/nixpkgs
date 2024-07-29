{
  lib,
  fetchpatch,
  kernel,
  kernelPatches,
  patchCommit ? "04fb9178158a7714aeb908c7a5310c4e0d6ea4b6",
  patchHash ? "sha256-LFn33xrX00M1WA5+z3ftNZVDEOE7qHNvCHym6QoSrkk=",
  argsOverride ? { },
  ...
}@args:
# NOTE: scx package should be updated simultaneously to preserve compatibility
(kernel.override (
  args
  // {

    argsOverride = {
      version = "${kernel.version}-scx";
      modDirVersion = kernel.modDirVersion;

      extraMeta = {
        homepage = "https://github.com/sched-ext/scx";
        description = "Linux kernel with sched ext patches";
        maintainers = with lib.maintainers; [ johnrtitor ];
      };
    } // argsOverride;

    structuredExtraConfig = with lib.kernel; {
      BPF = option yes;
      BPF_EVENTS = option yes;
      BPF_JIT = option yes;
      BPF_SYSCALL = option yes;
      BPF_JIT_DEFAULT_ON = option yes;
      BPF_JIT_ALWAYS_ON = lib.mkForce (option yes);
      PAHOLE_HAS_SPLIT_BTF = option yes;
      PAHOLE_HAS_BTF_TAG = option yes;
      DEBUG_INFO_BTF = option yes;
      FTRACE = option yes;
      SCHED_CLASS_EXT = option yes;

    };
    kernelPatches = [
      {
        # This patch is a fork of the original scx patch, which is now maintained by CachyOS team
        # original scx patches are often outdated and not maintained according to release schedule
        # of Nixpkgs, can be found in https://github.com/sched-ext/scx-kernel-releases
        name = "scx-${kernel.version}.patch";
        patch = fetchpatch {
          url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/${patchCommit}/${lib.versions.majorMinor kernel.version}/sched/0001-sched-ext.patch";
          hash = patchHash;
        };
      }
    ] ++ kernelPatches;
  }
))
