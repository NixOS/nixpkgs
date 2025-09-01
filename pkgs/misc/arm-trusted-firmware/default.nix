{ buildArmTrustedFirmware, stdenv }:

{
  armTrustedFirmwareTools = buildArmTrustedFirmware {
    makeFlags = [
      "HOSTCC=${stdenv.cc.targetPrefix}gcc"
      "fiptool"
      "certtool"
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

  armTrustedFirmwareAllwinner = buildArmTrustedFirmware (finalAttrs: {
    platform = "sun50i_a64";
    meta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "build/${finalAttrs.platform}/release/bl31.bin" ];
  });

  armTrustedFirmwareAllwinnerH616 = buildArmTrustedFirmware (finalAttrs: {
    platform = "sun50i_h616";
    meta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "build/${finalAttrs.platform}/release/bl31.bin" ];
  });

  armTrustedFirmwareAllwinnerH6 = buildArmTrustedFirmware (finalAttrs: {
    platform = "sun50i_h6";
    meta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "build/${finalAttrs.platform}/release/bl31.bin" ];
  });

  armTrustedFirmwareQemu = buildArmTrustedFirmware (finalAttrs: {
    platform = "qemu";
    meta.platforms = [ "aarch64-linux" ];
    filesToInstall = [
      "build/${finalAttrs.platform}/release/bl1.bin"
      "build/${finalAttrs.platform}/release/bl2.bin"
      "build/${finalAttrs.platform}/release/bl31.bin"
    ];
  });

  armTrustedFirmwareRK3328 = buildArmTrustedFirmware (finalAttrs: {
    makeFlags = [ "bl31" ];
    platform = "rk3328";
    meta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "build/${finalAttrs.platform}/release/bl31/bl31.elf" ];
  });

  armTrustedFirmwareRK3399 = buildArmTrustedFirmware (finalAttrs: {
    makeFlags = [ "bl31" ];
    platform = "rk3399";
    meta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "build/${finalAttrs.platform}/release/bl31/bl31.elf" ];
    platformCanUseHDCPBlob = true;
  });

  armTrustedFirmwareRK3568 = buildArmTrustedFirmware (finalAttrs: {
    makeFlags = [ "bl31" ];
    platform = "rk3568";
    meta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "build/${finalAttrs.platform}/release/bl31/bl31.elf" ];
  });

  armTrustedFirmwareRK3588 = buildArmTrustedFirmware (finalAttrs: {
    makeFlags = [ "bl31" ];
    platform = "rk3588";
    meta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "build/${finalAttrs.platform}/release/bl31/bl31.elf" ];
  });

  armTrustedFirmwareS905 = buildArmTrustedFirmware (finalAttrs: {
    makeFlags = [ "bl31" ];
    platform = "gxbb";
    meta.platforms = [ "aarch64-linux" ];
    filesToInstall = [ "build/${finalAttrs.platform}/release/bl31.bin" ];
  });
}
