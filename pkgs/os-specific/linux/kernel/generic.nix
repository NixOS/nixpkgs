{ stdenv, perl, linuxManualConfig

, # The kernel source tarball.
  src

, # The kernel version.
  version

, # The version number used for the module directory
  modDirVersion ? version

, # The kernel configuration.
  config

, # The kernel configuration when cross building.
  configCross ? {}

, # An attribute set whose attributes express the availability of
  # certain features in this kernel.  E.g. `{efiBootStub = true;}'
  # indicates a kernel that provides Intel wireless support.  Used in
  # NixOS to implement kernel-specific behaviour.
  features ? {}

, # A list of patches to apply to the kernel.  Each element of this list
  # should be an attribute set {name, patch} where `name' is a
  # symbolic name and `patch' is the actual patch.  The patch may
  # optionally be compressed with gzip or bzip2.
  kernelPatches ? []

, extraMeta ? {}
, ...
}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux"
  || stdenv.isArm || stdenv.system == "mips64el-linux";

assert stdenv.platform.name == "sheevaplug" -> stdenv.platform.uboot != null;

let

  lib = stdenv.lib;

  kernelConfigFun = baseConfig:
    let
      configFromPatches =
        map ({extraConfig ? "", ...}: extraConfig) kernelPatches;
    in lib.concatStringsSep "\n" ([baseConfig] ++ configFromPatches);

  configfile = stdenv.mkDerivation {
    name = "linux-config-${version}";

    generateConfig = ./generate-config.pl;

    kernelConfig = kernelConfigFun config;

    # For UML and non-PC, just ignore all options that don't apply (We are lazy).
    ignoreConfigErrors = stdenv.platform.name != "pc";

    nativeBuildInputs = [ perl ];

    platformName = stdenv.platform.name;
    kernelBaseConfig = stdenv.platform.kernelBaseConfig;
    kernelTarget = stdenv.platform.kernelTarget;
    autoModules = stdenv.platform.kernelAutoModules;
    arch = stdenv.platform.kernelArch;

    crossAttrs = let
        cp = stdenv.cross.platform;
      in {
        arch = cp.kernelArch;
        platformName = cp.name;
        kernelBaseConfig = cp.kernelBaseConfig;
        kernelTarget = cp.kernelTarget;
        autoModules = cp.kernelAutoModules;

        # Just ignore all options that don't apply (We are lazy).
        ignoreConfigErrors = true;

        kernelConfig = kernelConfigFun configCross;
      };

    buildCommand = ''
      # Get a basic config file for later refinement with $generateConfig.
      make -C ${kernel.sourceRoot} O=$PWD $kernelBaseConfig ARCH=$arch

      # Create the config file.
      echo "generating kernel configuration..."
      echo "$kernelConfig" > kernel-config
      DEBUG=1 ARCH=$arch KERNEL_CONFIG=kernel-config AUTO_MODULES=$autoModules \
           SRC=${kernel.sourceRoot} perl -w $generateConfig
      mv .config $out
    '';
  };

  kernel = linuxManualConfig {
    inherit version modDirVersion src kernelPatches;

    configfile = configfile.nativeDrv or configfile;

    crossConfigfile = configfile.crossDrv or configfile;

    config = { CONFIG_MODULES = "y"; CONFIG_FW_LOADER = "m"; };

    crossConfig = { CONFIG_MODULES = "y"; CONFIG_FW_LOADER = "m"; };
  };

  passthru = {
    # Combine the `features' attribute sets of all the kernel patches.
    features = lib.fold (x: y: (x.features or {}) // y) features kernelPatches;

    meta = kernel.meta // extraMeta;
  };

  nativeDrv = lib.addPassthru kernel.nativeDrv passthru;

  crossDrv = lib.addPassthru kernel.crossDrv passthru;
in if kernel ? crossDrv then nativeDrv // { inherit nativeDrv crossDrv; } else lib.addPassthru kernel passthru
