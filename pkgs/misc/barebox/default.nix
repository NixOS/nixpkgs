{ stdenv
, lib
, fetchurl
, bison
, dtc
, flex
, libusb1
, lzop
, openssl
, pkg-config
, buildPackages
}:

let
  buildBarebox = {
    filesToInstall
  , installDir ? "$out"
  , defconfig
  , extraMeta ? {}
  , ... } @ args: stdenv.mkDerivation rec {
    pname = "barebox-${defconfig}";

    version = "2020.12.0";

    src = fetchurl {
      url = "https://www.barebox.org/download/barebox-${version}.tar.bz2";
      sha256 = "06vsd95ihaa2nywpqy6k0c7xwk2pzws4yvbp328yd2pfiigachrv";
    };

    postPatch = ''
      patchShebangs scripts
    '';

    nativeBuildInputs = [
      bison
      dtc
      flex
      openssl
      libusb1
      lzop
      pkg-config
    ];
    depsBuildBuild = [ buildPackages.stdenv.cc ];

    hardeningDisable = [ "all" ];

    makeFlags = [
      "DTC=dtc"
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ];

    configurePhase = ''
      runHook preConfigure

      make ${defconfig}

      runHook postConfigure
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${lib.concatStringsSep " " filesToInstall} ${installDir}

      runHook postInstall
    '';

    enableParallelBuilding = true;

    dontStrip = true;

    meta = with lib; {
      homepage = "https://www.barebox.org";
      description = "The Swiss Army Knive for bare metal";
      license = licenses.gpl2;
      maintainers = with maintainers; [ emantor ];
    } // extraMeta;
  } // removeAttrs args [ "extraMeta" ];

in {
  inherit buildBarebox;

  bareboxTools = buildBarebox {
    defconfig = "hosttools_defconfig";
    installDir = "$out/bin";
    extraMeta.platforms = lib.platforms.linux;
    filesToInstall = [
      "scripts/bareboximd"
      "scripts/imx/imx-usb-loader"
      "scripts/omap4_usbboot"
      "scripts/omap3-usb-loader"
      "scripts/kwboot"
    ];
  };
}
