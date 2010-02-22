{ system, pkgs}:
with pkgs;
rec {
  pc = assert system == "i686-linux" || system == "x86_64-linux"; {
    name = "pc";
    uboot = null;
    kernelBaseConfig = "defconfig";
    # Build whatever possible as a module, if not stated in the extra config.
    kernelAutoModules = true;
    kernelTarget = "bzImage";
    kernelExtraConfig =
      ''
        # Virtualisation (KVM, Xen...).
        PARAVIRT_GUEST y
        KVM_CLOCK y
        KVM_GUEST y
        XEN y
        KSM y

        # We need 64 GB (PAE) support for Xen guest support.
        HIGHMEM64G? y
      '';
  };

  sheevaplug = {
    name = "sheevaplug";
    kernelBaseConfig = "kirkwood_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelExtraConfig =
      ''
        BLK_DEV_RAM y
        BLK_DEV_INITRD y
        MD y

        # Fail to build
        DRM n
        SCSI_ADVANSYS n
        USB_ISP1362_HCD n
        SND_SOC n
        SND_ALI5451 n
        FB_SAVAGE n
        SCSI_NSP32 n
        ATA_SFF n
        SUNGEM n
        IRDA n
        ATM_HE n
        SCSI_ACARD n
        BLK_DEV_CMD640_ENHANCED n
      '';
    kernelTarget = "uImage";
    uboot = ubootSheevaplug;
    # Only for uboot = uboot :
    ubootConfig = "sheevaplug_config";
  };

  versatileARM = {
    name = "versatileARM";
    kernelBaseConfig = "versatile_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelTarget = "zImage";
    kernelExtraConfig =
      ''
        MMC_ARMMMCI y
        MMC_SDHCI y
        SERIO_AMBAKMI y

        AEABI y
      '';
    uboot = null;
  };

  integratorCP = {
    name = "integratorCP";
    kernelBaseConfig = "integrator_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelTarget = "zImage";
    kernelExtraConfig =
      ''
        # needed for qemu integrator/cp
        SERIAL_AMBA_PL011 y
        SERIAL_AMBA_PL011_CONSOLE y
        SERIAL_AMBA_PL010 n
        SERIAL_AMBA_PL010_CONSOLE n

        MMC_ARMMMCI y
        MMC_SDHCI y
        SERIO_AMBAKMI y

        CPU_ARM926T y
        ARCH_INTEGRATOR_CP y
        VGA_CONSOLE n
        AEABI y
      '';
    uboot = null;
    ubootConfig = "integratorcp_config";
  };

  integratorCPuboot = integratorCP // {
    name = "integratorCPuboot";
    kernelTarget = "uImage";
    uboot = uboot;
    ubootConfig = "integratorcp_config";
  };
}
