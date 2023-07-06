###! Libre Power Management firmware for sunxi System On Chip ("SoC") for implementing system suspend/resume, and (onboards without a PMIC) soft poweroff/on. The package has to be built using (OpenRISC 1000, *not RISC-V*) compiler which is officially supported in upstream GCC starting with GCC 9.1.0.
###!
###! To build only the crust firmware derivation use:
###!   $ nix-build -A pkgsCross.or1k.crustTeresA64
###!
###! When packaging for linux make sure that you have the following patches otherwise crust won't be able to cleanly share the clock controller and PMIC bus controller hardware: https://github.com/torvalds/linux/compare/master...crust-firmware:linux:crust
###!
###! If you are faced with issues while building the firmware then take a look at https://github.com/crust-firmware/crust#building-the-firmware

{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, bison
, flex
, buildPackages
}:

###! The package declaration is heavily inspired by the U-Boot package to make maintenance easier, but should stay as an invidual declaration since it's processing has different requirements and including it in the U-Boot would bloat the definition and would be harder to understand and maintain

let
  defaultVersion = "unstable-2023-03-04";
  defaultSrc = fetchFromGitHub {
    owner = "crust-firmware";
    repo = "crust";
    rev = "c308a504853e7fdb47169796c9a832796410ece8";
    sha256 = "AobVD3Jo/6s0cExHXpYYAqZv/gCplxLlDYVscSCIS6M=";
  };
  buildCrust = {
    version ? defaultVersion
  , src ? defaultSrc
  , defconfig
  , extraConfig ? ""
  , extraPatches ? []
  , extraMakeFlags ? []
  , extraMeta ? {}
  , ... } @ args: stdenv.mkDerivation ({
    # Strip "_defconfig" suffix from 'defconfig' if it's present for clearer output
    # builtins.match returns 'Null' if the string matches so we have to then check if it's Null
    # FIXME-QA(Krey): I hate this, but am not aware of better way to write this
    pname = if (builtins.isNull ((builtins.match "_defconfig$" defconfig)))
      then "crust-${lib.strings.removeSuffix "_defconfig" defconfig}"
      else "crust-${defconfig}";

    inherit version;
    inherit src;

    ###! The package has upstream definitions of configurations for set devices and thus the defconfig has to be always included, beyond that the options are designed to be as flexible as possible to accompany special requirements of various devices
    ###!
    ###! Avoid declaring extra configuration (extraConfig) when possible as those should go to the upstream unless you use special usecase device e.g. modded teres-A64

    defconfig = if defconfig == null then
      throw "crust config not defined!"
      else defconfig;

    # Only for global crust patches, per-device paches should be included as extras to avoid adding noise which would complicate debugging
    patches = [] ++ extraPatches;

    postPatch = "";

    nativeBuildInputs = [
      flex
      bison
    ];

    depsBuildBuild = [ buildPackages.stdenv.cc ];

    makeFlags = [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ] ++ extraMakeFlags;

    ###! Phases
    configurePhase = ''
      runHook preConfigure

      echo "Configuring for ${defconfig}"
      make ${defconfig}

      # The variable 'extraConfigPath' is often parsed as blank resulting in a scenario where `cat` is expecting interactive input followed by line-break to continue, this is to reduce the risk of that happening
      [ -z "$extraConfigPath" ] || {
        cat $extraConfigPath >> .config
      }

      runHook postConfigure
    '';

    # The package has only one output which is located in `build/scp/scp.bin`
    installPhase = ''
      runHook preInstall

      mkdir "$out"
      cp -v "build/scp/scp.bin" "$out/scp.bin"

      runHook postInstall
    '';

    ###! Hardening
    ###! * 'bindnow' is ignored by the package
    ###! * 'pie' is already applied by default to musl and disabled for glibc where in our scenario it seems to be unsupported
    ###! * 'relro' is ignored by the package, likely due to it breaking dynamic objects. Issue https://github.com/crust-firmware/crust/issues/216 has been submitted to verify
    ###! Refer to https://nixos.org/manual/nixpkgs/stable/#sec-hardening-in-nixpkgs for details
    hardeningDisable = [
      "bindnow"
      "relro"
    ];

    # Default Metadata
    meta = with lib; {
      homepage = "https://github.com/crust-firmware/crust";
      # Try to adjust the description per package so that it's not all with generic wording
      description = "SCP (power management) firmware for sunxi SoCs";
      # Project using 3rdparty components https://github.com/crust-firmware/crust/blob/master/LICENSE.md#crust-firmware-licensing
      license = with licenses; [
        bsd1
        bsd3
        mit
        gpl2
      ];
    } // extraMeta;
  } // removeAttrs args [ "extraMeta" ]);

in {
  inherit buildCrust;

  # Example configuration:
  ## crustExample = buildCrust {
  ##   defconfig = "example_defconfig";
  ##   extraMeta = {
  ##     description = "SCP (power management) firmware for Example";
  ##     platforms = [ "or1k-none" ];
  ##     maintainers = with lib.maintainers; [ your-usename-here ];
  ##   };
  ## };

  crustTeresA64 = buildCrust {
    defconfig = "teres_i_defconfig";
    extraMeta = {
      description = "SCP (power management) firmware for the odrysian king";
      platforms = [ "or1k-none" ];
      maintainers = with lib.maintainers; [ kreyren ];
    };
  };
}
