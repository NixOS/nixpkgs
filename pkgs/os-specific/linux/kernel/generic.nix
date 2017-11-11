{ stdenv, perl, buildLinux

, # The kernel source tarball.
  src

, # The kernel version.
  version

, # Overrides to the kernel config.
  extraConfig ? ""

, # The version number used for the module directory
  modDirVersion ? version

, # An attribute set whose attributes express the availability of
  # certain features in this kernel.  E.g. `{iwlwifi = true;}'
  # indicates a kernel that provides Intel wireless support.  Used in
  # NixOS to implement kernel-specific behaviour.
  features ? {}

, # A list of patches to apply to the kernel.  Each element of this list
  # should be an attribute set {name, patch} where `name' is a
  # symbolic name and `patch' is the actual patch.  The patch may
  # optionally be compressed with gzip or bzip2.
  kernelPatches ? []
, ignoreConfigErrors ? stdenv.platform.name != "pc"
, extraMeta ? {}
, hostPlatform
, ...
}:

assert stdenv.isLinux;

let

  lib = stdenv.lib;

  # Combine the `features' attribute sets of all the kernel patches.
  kernelFeatures = lib.fold (x: y: (x.features or {}) // y) ({
    iwlwifi = true;
    efiBootStub = true;
    needsCifsUtils = true;
    netfilterRPFilter = true;
  } // features) kernelPatches;

  configWithPlatform = kernelPlatform: import ./common-config.nix {
    inherit stdenv version kernelPlatform extraConfig;
    features = kernelFeatures; # Ensure we know of all extra patches, etc.
  };

  config = configWithPlatform stdenv.platform;
  configCross = configWithPlatform hostPlatform.platform;

  kernelConfigFun = baseConfig:
    let
      configFromPatches =
        map ({extraConfig ? "", ...}: extraConfig) kernelPatches;
    in lib.concatStringsSep "\n" ([baseConfig] ++ configFromPatches);

  configfile = stdenv.mkDerivation {
    inherit ignoreConfigErrors;
    name = "linux-config-${version}";

    generateConfig = ./generate-config.pl;

    kernelConfig = kernelConfigFun config;

    nativeBuildInputs = [ perl ];

    platformName = stdenv.platform.name;
    kernelBaseConfig = stdenv.platform.kernelBaseConfig;
    kernelTarget = stdenv.platform.kernelTarget;
    autoModules = stdenv.platform.kernelAutoModules;
    preferBuiltin = stdenv.platform.kernelPreferBuiltin or false;
    arch = stdenv.platform.kernelArch;

    crossAttrs = let
        cp = hostPlatform.platform;
      in {
        arch = cp.kernelArch;
        platformName = cp.name;
        kernelBaseConfig = cp.kernelBaseConfig;
        kernelTarget = cp.kernelTarget;
        autoModules = cp.kernelAutoModules;

        # Just ignore all options that don't apply (We are lazy).
        ignoreConfigErrors = true;

        kernelConfig = kernelConfigFun configCross;

        inherit (kernel.crossDrv) src patches preUnpack;
      };

    prePatch = kernel.prePatch + ''
      # Patch kconfig to print "###" after every question so that
      # generate-config.pl from the generic builder can answer them.
      sed -e '/fflush(stdout);/i\printf("###");' -i scripts/kconfig/conf.c
    '';

    inherit (kernel) src patches preUnpack;

    buildPhase = ''
      cd $buildRoot

      # Get a basic config file for later refinement with $generateConfig.
      make -C ../$sourceRoot O=$PWD $kernelBaseConfig ARCH=$arch

      # Create the config file.
      echo "generating kernel configuration..."
      echo "$kernelConfig" > kernel-config
      DEBUG=1 ARCH=$arch KERNEL_CONFIG=kernel-config AUTO_MODULES=$autoModules \
           PREFER_BUILTIN=$preferBuiltin SRC=../$sourceRoot perl -w $generateConfig
    '';

    installPhase = "mv .config $out";

    enableParallelBuilding = true;
  };

  kernel = buildLinux {
    inherit version modDirVersion src kernelPatches stdenv;

    configfile = configfile.nativeDrv or configfile;

    crossConfigfile = configfile.crossDrv or configfile;

    config = { CONFIG_MODULES = "y"; CONFIG_FW_LOADER = "m"; };

    crossConfig = { CONFIG_MODULES = "y"; CONFIG_FW_LOADER = "m"; };
  };

  passthru = {
    features = kernelFeatures;

    meta = kernel.meta // extraMeta;

    passthru = kernel.passthru // (removeAttrs passthru [ "passthru" "meta" ]);
  };

  nativeDrv = lib.addPassthru kernel.nativeDrv passthru;

  crossDrv = lib.addPassthru kernel.crossDrv passthru;

in if kernel ? crossDrv
   then nativeDrv // { inherit nativeDrv crossDrv; }
   else lib.addPassthru kernel passthru
