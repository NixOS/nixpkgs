# Kernel for https://wiki.pine64.org/wiki/PinePhone_Pro
{ lib, stdenv, fetchFromGitLab, fetchpatch, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.16.0";

  src = fetchFromGitLab {
    owner = "pine64-org";
    repo = "linux";
    # https://gitlab.com/pine64-org/linux/-/tree/pine64-kernel-ppp-5.16.y
    rev = "cbaae8db31215ed315a8e3f66a075c278a5777ea";
    hash = "sha256-w+7MMdGpKs5YpCN6uOCaP0F0GxdiDPiECIm7LLPurGA=";
  };

  defconfig = "defconfig";

  structuredExtraConfig = with lib.kernel; {
    # Compilation error.
    #     gcc: error: unrecognized command line option '-mfloat-abi=softfp'
    #     gcc: error: unrecognized command line option '-mfpu=neon'
    FB_SUN5I_EINK = no;

    IP5XXX_POWER = module;

    BATTERY_RK818 = yes;
    CHARGER_RK818 = yes;
  };

  kernelPatches = [];
} // (args.argsOverride or {}))
