{ lib, stdenv, fetchFromGitHub, fetchFromGitLab, openssl, pkgsCross, buildPackages

# Warning: this blob (hdcp.bin) runs on the main CPU (not the GPU) at
# privilege level EL3, which is above both the kernel and the
# hypervisor.
#
# This parameter applies only to platforms which are believed to use
# hdcp.bin. On all other platforms, or if unfreeIncludeHDCPBlob=false,
# hdcp.bin will be deleted before building.
, unfreeIncludeHDCPBlob ? true
}:

let
  buildArmTrustedFirmware = { filesToInstall
            , installDir ? "$out"
            , platform ? null
            , platformCanUseHDCPBlob ? false  # set this to true if the platform is able to use hdcp.bin
            , extraMakeFlags ? []
            , extraMeta ? {}
            , ... } @ args:

           # delete hdcp.bin if either: the platform is thought to
           # not need it or unfreeIncludeHDCPBlob is false
           let deleteHDCPBlobBeforeBuild = !platformCanUseHDCPBlob || !unfreeIncludeHDCPBlob; in

           stdenv.mkDerivation (rec {

    pname = "arm-trusted-firmware${lib.optionalString (platform != null) "-${platform}"}";
    version = "2.10.0";

    src = fetchFromGitHub {
      owner = "ARM-software";
      repo = "arm-trusted-firmware";
      rev = "v${version}";
      hash = "sha256-CAuftVST9Fje/DWaaoX0K2SfWwlGMaUFG4huuwsTOSU=";
    };

    patches = lib.optionals deleteHDCPBlobBeforeBuild [
      # this is a rebased version of https://gitlab.com/vicencb/kevinboot/-/blob/master/atf.patch
      ./remove-hdcp-blob.patch
    ];

    postPatch = lib.optionalString deleteHDCPBlobBeforeBuild ''
      rm plat/rockchip/rk3399/drivers/dp/hdcp.bin
    '';

    depsBuildBuild = [ buildPackages.stdenv.cc ];

    # For Cortex-M0 firmware in RK3399
    nativeBuildInputs = [ pkgsCross.arm-embedded.stdenv.cc ];

    buildInputs = [ openssl ];

    makeFlags = [
      "HOSTCC=$(CC_FOR_BUILD)"
      "M0_CROSS_COMPILE=${pkgsCross.arm-embedded.stdenv.cc.targetPrefix}"
      "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
      # binutils 2.39 regression
      # `warning: /build/source/build/rk3399/release/bl31/bl31.elf has a LOAD segment with RWX permissions`
      # See also: https://developer.trustedfirmware.org/T996
      "LDFLAGS=-no-warn-rwx-segments"
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
      description = "Reference implementation of secure world software for ARMv8-A";
      license = [ licenses.bsd3 ] ++ lib.optionals (!deleteHDCPBlobBeforeBuild) [ licenses.unfreeRedistributable ];
      maintainers = with maintainers; [ lopsided98 ];
    } // extraMeta;
  } // builtins.removeAttrs args [ "extraMeta" ]);

in {
  inherit buildArmTrustedFirmware;

  armTrustedFirmwareTools = buildArmTrustedFirmware rec {
    # Normally, arm-trusted-firmware builds the build tools for buildPlatform
    # using CC_FOR_BUILD (or as it calls it HOSTCC). Since want to build them
    # for the hostPlatform here, we trick it by overriding the HOSTCC setting
    # and, to be safe, remove CC_FOR_BUILD from the environment.
    depsBuildBuild = [ ];
    extraMakeFlags = [
      "HOSTCC=${stdenv.cc.targetPrefix}gcc"
      "fiptool" "certtool"
    ];
    filesToInstall = [
      "tools/fiptool/fiptool"
      "tools/cert_create/cert_create"
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

  armTrustedFirmwareAllwinnerH6 = buildArmTrustedFirmware rec {
    platform = "sun50i_h6";
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
    platformCanUseHDCPBlob = true;
  };

  armTrustedFirmwareRK3588 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "rk3588";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31/bl31.elf"];
    platformCanUseHDCPBlob = true;

    # TODO: remove this once the following get merged:
    # 1: https://review.trustedfirmware.org/c/TF-A/trusted-firmware-a/+/21840
    # 2: https://review.trustedfirmware.org/c/ci/tf-a-ci-scripts/+/21833
    src = fetchFromGitLab {
      domain = "gitlab.collabora.com";
      owner = "hardware-enablement/rockchip-3588";
      repo = "trusted-firmware-a";
      rev = "002d8e85ce5f4f06ebc2c2c52b4923a514bfa701";
      hash = "sha256-1XOG7ILIgWa3uXUmAh9WTfSGLD/76OsmWrUhIxm/zTg=";
    };
  };

  armTrustedFirmwareS905 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "gxbb";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31.bin"];
  };
}
