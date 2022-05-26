{ lib
, stdenv
, fetchFromGitHub
, openssl
, pkgsCross
, buildPackages
, buildArmTrustedFirmware

# Warning: this blob (hdcp.bin) runs on the main CPU (not the GPU) at
# privilege level EL3, which is above both the kernel and the
# hypervisor.
#
# This parameter applies only to platforms which are believed to use
# hdcp.bin. On all other platforms, or if unfreeIncludeHDCPBlob=false,
# hdcp.bin will be deleted before building.
, unfreeIncludeHDCPBlob ? true
}:

{
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
    deleteHDCPBlobBeforeBuild = true;
  };

  armTrustedFirmwareAllwinner = buildArmTrustedFirmware rec {
    platform = "sun50i_a64";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["build/${platform}/release/bl31.bin"];
    deleteHDCPBlobBeforeBuild = true;
  };

  armTrustedFirmwareAllwinnerH616 = buildArmTrustedFirmware rec {
    platform = "sun50i_h616";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = ["build/${platform}/release/bl31.bin"];
    deleteHDCPBlobBeforeBuild = true;
  };

  armTrustedFirmwareQemu = buildArmTrustedFirmware rec {
    platform = "qemu";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [
      "build/${platform}/release/bl1.bin"
      "build/${platform}/release/bl2.bin"
      "build/${platform}/release/bl31.bin"
    ];
    deleteHDCPBlobBeforeBuild = true;
  };

  armTrustedFirmwareRK3328 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "rk3328";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31/bl31.elf"];
    deleteHDCPBlobBeforeBuild = !unfreeIncludeHDCPBlob;
  };

  armTrustedFirmwareRK3399 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "rk3399";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31/bl31.elf"];
    deleteHDCPBlobBeforeBuild = !unfreeIncludeHDCPBlob;
  };

  armTrustedFirmwareS905 = buildArmTrustedFirmware rec {
    extraMakeFlags = [ "bl31" ];
    platform = "gxbb";
    extraMeta.platforms = ["aarch64-linux"];
    filesToInstall = [ "build/${platform}/release/bl31.bin"];
    deleteHDCPBlobBeforeBuild = true;
  };
}
