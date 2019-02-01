{ buildPackages
, ncurses
, callPackage
, perl
, bison ? null
, flex ? null
, gmp ? null
, libmpc ? null
, mpfr ? null
, stdenv

, # The kernel source tarball.
  src

, # The kernel version.
  version

, # Allows overriding the default defconfig
  defconfig ? null

, # Legacy overrides to the intermediate kernel config, as string
  extraConfig ? ""

, # kernel intermediate config overrides, as a set
 structuredExtraConfig ? {}

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
, ignoreConfigErrors ? stdenv.hostPlatform.platform.name != "pc" ||
                       stdenv.hostPlatform != stdenv.buildPlatform
, extraMeta ? {}

# easy overrides to stdenv.hostPlatform.platform members
, autoModules ? stdenv.hostPlatform.platform.kernelAutoModules
, preferBuiltin ? stdenv.hostPlatform.platform.kernelPreferBuiltin or false
, kernelArch ? stdenv.hostPlatform.platform.kernelArch

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
    grsecurity = false;
    xen_dom0 = false;
    ia32Emulation = true;
  } // features) kernelPatches;

  commonStructuredConfig = import ./common-config.nix {
    inherit stdenv version ;

    features = kernelFeatures; # Ensure we know of all extra patches, etc.
  };

  intermediateNixConfig = configfile.moduleStructuredConfig.intermediateNixConfig
    # extra config in legacy string format
    + extraConfig
    + lib.optionalString (stdenv.hostPlatform.platform ? kernelExtraConfig) stdenv.hostPlatform.platform.kernelExtraConfig;

  structuredConfigFromPatches =
        map ({extraStructuredConfig ? {}, ...}: {settings=extraStructuredConfig;}) kernelPatches;

  # appends kernel patches extraConfig
  kernelConfigFun = baseConfigStr:
    let
      configFromPatches =
        map ({extraConfig ? "", ...}: extraConfig) kernelPatches;
    in lib.concatStringsSep "\n" ([baseConfigStr] ++ configFromPatches);

  configfile = stdenv.mkDerivation {
    inherit ignoreConfigErrors autoModules preferBuiltin kernelArch;
    name = "linux-config-${version}";

    generateConfig = ./generate-config.pl;

    kernelConfig = kernelConfigFun intermediateNixConfig;
    passAsFile = [ "kernelConfig" ];

    depsBuildBuild = [ buildPackages.stdenv.cc ];
    nativeBuildInputs = [ perl gmp libmpc mpfr ]
      ++ lib.optionals (stdenv.lib.versionAtLeast version "4.16") [ bison flex ];

    platformName = stdenv.hostPlatform.platform.name;
    # e.g. "defconfig"
    kernelBaseConfig = if defconfig != null then defconfig else stdenv.hostPlatform.platform.kernelBaseConfig;
    # e.g. "bzImage"
    kernelTarget = stdenv.hostPlatform.platform.kernelTarget;

    prePatch = kernel.prePatch + ''
      # Patch kconfig to print "###" after every question so that
      # generate-config.pl from the generic builder can answer them.
      sed -e '/fflush(stdout);/i\printf("###");' -i scripts/kconfig/conf.c
    '';

    preUnpack = kernel.preUnpack or "";

    inherit (kernel) src patches;

    buildPhase = ''
      export buildRoot="''${buildRoot:-build}"

      # Get a basic config file for later refinement with $generateConfig.
      make -C .  O="$buildRoot" $kernelBaseConfig \
          ARCH=$kernelArch \
          HOSTCC=${buildPackages.stdenv.cc.targetPrefix}gcc \
          HOSTCXX=${buildPackages.stdenv.cc.targetPrefix}g++

      # Create the config file.
      echo "generating kernel configuration..."
      ln -s "$kernelConfigPath" "$buildRoot/kernel-config"
      DEBUG=1 ARCH=$kernelArch KERNEL_CONFIG="$buildRoot/kernel-config" AUTO_MODULES=$autoModules \
           PREFER_BUILTIN=$preferBuiltin BUILD_ROOT="$buildRoot" SRC=. perl -w $generateConfig
    '';

    installPhase = "mv $buildRoot/.config $out";

    enableParallelBuilding = true;

    passthru = rec {

      module = import ../../../../nixos/modules/system/boot/kernel_config.nix;
      # used also in apache
      # { modules = [ { options = res.options; config = svc.config or svc; } ];
      #   check = false;
      # The result is a set of two attributes
      moduleStructuredConfig = (lib.evalModules {
        modules = [
          module
          { settings = commonStructuredConfig; }
          { settings = structuredExtraConfig; }
        ]
        ++  structuredConfigFromPatches
        ;
      }).config;

      #
      structuredConfig = moduleStructuredConfig.settings;
    };


  }; # end of configfile derivation

  kernel = (callPackage ./manual-config.nix {}) {
    inherit version modDirVersion src kernelPatches stdenv extraMeta configfile;

    config = { CONFIG_MODULES = "y"; CONFIG_FW_LOADER = "m"; };
  };

  passthru = {
    features = kernelFeatures;
    inherit commonStructuredConfig;
    passthru = kernel.passthru // (removeAttrs passthru [ "passthru" ]);
  };

in lib.extendDerivation true passthru kernel
