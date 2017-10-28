{ stdenv, buildPackages, perl, buildLinux

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
, ignoreConfigErrors ? hostPlatform.platform.name != "pc"
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
    #inherit ignoreConfigErrors;
    name = "linux-config-${version}";

    generateConfig = ./generate-config.pl;

    kernelConfig = kernelConfigFun config;

    nativeBuildInputs = [ buildPackages.stdenv.cc perl ];

    platformName = hostPlatform.platform.name;
    kernelBaseConfig = hostPlatform.platform.kernelBaseConfig;
    kernelTarget = hostPlatform.platform.kernelTarget;
    autoModules = hostPlatform.platform.kernelAutoModules;
    preferBuiltin = hostPlatform.platform.kernelPreferBuiltin or false;
    arch = hostPlatform.platform.kernelArch;

    # TODO(@Ericson2314): No null next hash break
    ignoreConfigErrors = if stdenv.hostPlatform == stdenv.buildPlatform then null else true;

    crossAttrs = let
        cp = hostPlatform.platform;
      in {
        ignoreConfigErrors = true;
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
      make HOSTCC=${buildPackages.stdenv.cc.targetPrefix}gcc -C ../$sourceRoot O=$PWD $kernelBaseConfig ARCH=$arch

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
    inherit version modDirVersion src kernelPatches stdenv extraMeta;

    configfile = configfile.nativeDrv or configfile;

    config = { CONFIG_MODULES = "y"; CONFIG_FW_LOADER = "m"; };
  };

  passthru = {
    features = kernelFeatures;
    passthru = kernel.passthru // (removeAttrs passthru [ "passthru" ]);
  };

in lib.extendDerivation true passthru kernel
