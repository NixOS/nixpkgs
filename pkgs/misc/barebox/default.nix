{
  stdenv,
  lib,
  fetchurl,
  bison,
  dtc,
  flex,
  libusb1,
  lzop,
  openssl,
  pkg-config,
  buildPackages,
}:

let
  defaultVersion = "2025.04.0";
  defaultSrc = fetchurl {
    url = "https://www.barebox.org/download/barebox-${defaultVersion}.tar.bz2";
    sha256 = "sha256-MSTzwradnOBRKy1A+hfKzpw1b2XwBaY9oEdDh7iDnEE=";
  };

  buildBarebox = lib.makeOverridable (
    {
      version ? null,
      src ? null,
      filesToInstall,
      installDir ? "$out",
      defconfig,
      extraMeta ? { },
      ...
    }@args:
    stdenv.mkDerivation (finalAttrs: {
      pname = "barebox-${defconfig}";

      version = if src == null then defaultVersion else version;

      src = if src == null then defaultSrc else src;

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

      meta =
        with lib;
        {
          homepage = "https://www.barebox.org";
          description = "Swiss Army Knive for bare metal";
          license = licenses.gpl2Only;
          maintainers = with maintainers; [ emantor ];
        }
        // extraMeta;
    })
    // removeAttrs args [ "extraMeta" ]
  );
in
{
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
      "scripts/rk-usb-loader"
    ];
  };
}
