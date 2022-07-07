{ lib, stdenv, fetchFromGitHub, openssl, pkgsCross, buildPackages

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
            , version ? "2.7"
            , ... } @ args:

           # delete hdcp.bin if either: the platform is thought to
           # not need it or unfreeIncludeHDCPBlob is false
           let deleteHDCPBlobBeforeBuild = !platformCanUseHDCPBlob || !unfreeIncludeHDCPBlob; in

           stdenv.mkDerivation ({

    pname = "arm-trusted-firmware${lib.optionalString (platform != null) "-${platform}"}";
    inherit version;

    src = fetchFromGitHub {
      owner = "ARM-software";
      repo = "arm-trusted-firmware";
      rev = "v${version}";
      sha256 = "sha256-WDJMMIWZHNqxxAKeHiZDxtPjfsfQAWsbYv+0o0PiJQs=";
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
      license = [ licenses.bsd3 ] ++ lib.optionals (!deleteHDCPBlobBeforeBuild) [ licenses.unfreeRedistributable ];
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
    platformCanUseHDCPBlob = true;
  };

  armTrustedFirmwareRK3399 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "rk3399";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31/bl31.elf"];
    platformCanUseHDCPBlob = true;
  };

  armTrustedFirmwareS905 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "gxbb";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31.bin"];
  };
}
