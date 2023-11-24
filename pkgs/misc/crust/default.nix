{ lib
, fetchurl
, fetchFromGitHub
, stdenv
, pkgsCross
, flex
, bison
, swig
, buildPackages
}:
let
  buildCrustFirmware = lib.makeOverridable (
    { filesToInstall ? [ "build/scp/scp.bin" ]
    , installDir ? "$out"
    , defconfig
    , extraConfig ? ""
    , extraPatches ? [ ]
    , extraMakeFlags ? [ ]
    , extraMeta ? { }
    , ...
    } @ args:

    stdenv.mkDerivation (rec {
      pname = "crust-scp-${defconfig}";
      version = "0.6";

      src = fetchFromGitHub {
        owner = "crust-firmware";
        repo = "crust";
        rev = "refs/tags/v${version}";
        hash = "sha256-zalBVP9rI81XshcurxmvoCwkdlX3gMw5xuTVLOIymK4=";
      };

      depsBuildBuild = [ buildPackages.stdenv.cc ];

      nativeBuildInputs = [ flex bison swig pkgsCross.or1k.stdenv.cc ];

      patches = [
      ] ++ extraPatches;

      passAsFile = [ "extraConfig" ];

      configurePhase = ''
        runHook preConfigure
        make ${defconfig}
        cat $extraConfigPath >> .config
        runHook postConfigure
      '';

      makeFlags = [
        "HOST_COMPILE="
        "CROSS_COMPILE=or1k-elf-"
      ] ++ extraMakeFlags;

      installPhase = ''
        runHook preInstall
        mkdir -p ${installDir}
        cp ${lib.concatStringsSep " " filesToInstall} ${installDir}
        runHook postInstall
      '';

      hardeningDisable = [ "all" ];
      dontStrip = true;

      enableParallelBuilding = true;

      meta = with lib; {
        homepage = "https://github.com/crust-firmware/crust";
        description = "SCP (power management) firmware for sunxi SoCs";
        license = [ licenses.bsd3 licenses.gpl2Only ];
        platforms = platforms.linux;
        maintainers = with maintainers; [ zaldnoay ];
      } // extraMeta;
    } // builtins.removeAttrs args [ "extraMeta" ])
  );
in
{
  inherit buildCrustFirmware;

  crustFirmwareOrangePi3LTS = buildCrustFirmware {
    extraPatches = [
      (fetchurl {
        url = "https://raw.githubusercontent.com/armbian/build/fd06307ebae7cc170f072f71687adbb65d707953/patch/crust/add-defconfig-for-orangepi-3-lts.patch";
        sha256 = "11dzphqzf8547fp35dj9n5zj55cqqbn7dzba6ybkrgkm0r66imx2";
      })
    ];
    defconfig = "orangepi_3_lts_defconfig";
  };

  crustFirmwareOlimexA64Teres1 = buildCrustFirmware {
    defconfig = "teres_i_defconfig";
  };
}
