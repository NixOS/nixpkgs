{ lib, stdenv, fetchFromGitHub, openssl, pkgsCross, buildPackages

# Warning: this blob runs on the main CPU (not the GPU) at privilege
# level EL3, which is above both the kernel and the hypervisor.
, unfreeIncludeHDCPBlob ? true
}:

let
  buildArmTrustedFirmware = { filesToInstall
            , installDir ? "$out"
            , platform ? null
            , extraMakeFlags ? []
            , extraMeta ? {}
            , version ? "2.6"
            , ... } @ args:
           stdenv.mkDerivation ({

    pname = "arm-trusted-firmware${lib.optionalString (platform != null) "-${platform}"}";
    inherit version;

    src = fetchFromGitHub {
      owner = "ARM-software";
      repo = "arm-trusted-firmware";
      rev = "v${version}";
      sha256 = "sha256-qT9DdTvMcUrvRzgmVf2qmKB+Rb1WOB4p1rM+fsewGcg=";
    };

    patches = lib.optionals (!unfreeIncludeHDCPBlob) [
      # this is a rebased version of https://gitlab.com/vicencb/kevinboot/-/blob/master/atf.patch
      ./remove-hdcp-blob.patch
    ];

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
      homepage = "https://github.com/ARM-software/arm-trusted-firmware";
      description = "A reference implementation of secure world software for ARMv8-A";
      license = (if unfreeIncludeHDCPBlob then [ licenses.unfreeRedistributable ] else []) ++ [ licenses.bsd3 ];
      maintainers = with maintainers; [ lopsided98 ];
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

  armTrustedFirmwareAllwinnerH616 = buildArmTrustedFirmware rec {
    platform = "sun50i_h616";
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
