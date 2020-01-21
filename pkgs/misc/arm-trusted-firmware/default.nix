{ lib, stdenv, fetchFromGitHub, fetchpatch, openssl, pkgsCross, buildPackages }:

let
  buildArmTrustedFirmware = { filesToInstall
            , installDir ? "$out"
            , platform ? null
            , extraMakeFlags ? []
            , extraMeta ? {}
            , version ? "2.1"
            , ... } @ args:
           stdenv.mkDerivation ({

    name = "arm-trusted-firmware${lib.optionalString (platform != null) "-${platform}"}-${version}";
    inherit version;

    src = fetchFromGitHub {
      owner = "ARM-software";
      repo = "arm-trusted-firmware";
      rev = "refs/tags/v${version}";
      sha256 = "1gy5qskrjy8n3kxdcm1dx8b45l5b75n0pm8pq80wl6xic1ycy24r";
    };

    depsBuildBuild = [ buildPackages.stdenv.cc ];

    # For Cortex-M0 firmware in RK3399
    nativeBuildInputs = [ pkgsCross.arm-embedded.stdenv.cc ];

    buildInputs = [ openssl ];

    makeFlags = [
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    ] ++ (lib.optional (platform != null) "PLAT=${platform}")
      ++ extraMakeFlags;

    installPhase = ''
      runHook preInstall

      mkdir -p ${installDir}
      cp ${lib.concatStringsSep " " filesToInstall} ${installDir}

      runHook postInstall
    '';

    hardeningDisable = [ "all" ];
    dontStrip = true;

    # Fatal error: can't create build/sun50iw1p1/release/bl31/sunxi_clocks.o: No such file or directory
    enableParallelBuilding = false;

    meta = with lib; {
      homepage = https://github.com/ARM-software/arm-trusted-firmware;
      description = "A reference implementation of secure world software for ARMv8-A";
      license = licenses.bsd3;
      maintainers = [ maintainers.lopsided98 ];
    } // extraMeta;
  } // builtins.removeAttrs args [ "extraMeta" ]);

in {
  inherit buildArmTrustedFirmware;

  armTrustedFirmwareTools = buildArmTrustedFirmware rec {
    extraMakeFlags = [
      "HOSTCC=${stdenv.cc.targetPrefix}gcc"
      "fiptool" "certtool" "sptool"
    ];
    filesToInstall = [
      "tools/fiptool/fiptool"
      "tools/cert_create/cert_create"
      "tools/sptool/sptool"
    ];
    postInstall = ''
      mkdir -p "$out/bin"
      find "$out" -type f -executable -exec mv -t "$out/bin" {} +
    '';
  };

  armTrustedFirmwareAllwinner = buildArmTrustedFirmware rec {
    platform = "sun50i_a64";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["build/${platform}/release/bl31.bin"];
  };

  armTrustedFirmwareQemu = buildArmTrustedFirmware rec {
    platform = "qemu";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [
      "build/${platform}/release/bl1.bin"
      "build/${platform}/release/bl2.bin"
      "build/${platform}/release/bl31.bin"
    ];
  };

  armTrustedFirmwareRK3328 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "rk3328";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31/bl31.elf"];
  };

  armTrustedFirmwareRK3399 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "rk3399";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31/bl31.elf"];
  };

  armTrustedFirmwareS905 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "gxbb";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31.bin"];
  };
}
