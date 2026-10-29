{
  lib,
  kernel,
  kernelModuleMakeFlags,
  makeSetupHook,
}:

makeSetupHook {
  name = "kernel-module-install-hook-${kernel.version}";
  substitutions = {
    kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
    # One shell-quoted array element per line, substituted directly into the
    # flags array literal in the hook script. Unlike a space-joined string
    # this keeps flags intact even if they contain literal spaces, and the
    # single quotes keep make syntax like kbuild's `$(space)` unexpanded
    # until make sees it.
    moduleInstallFlags = lib.concatMapStringsSep "\n" lib.escapeShellArg kernelModuleMakeFlags;
  };
  meta = {
    description = "Setup hook that installs out-of-tree kernel modules via the kernel's modules_install, so they are stripped, signed and compressed by the kernel build system";
    platforms = lib.platforms.linux;
  };
} ./module-install-hook.sh
