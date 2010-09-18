rec {
  pc = {
    name = "pc";
    uboot = null;
    kernelHeadersBaseConfig = "defconfig";
    kernelBaseConfig = "defconfig";
    # Build whatever possible as a module, if not stated in the extra config.
    kernelAutoModules = true;
    kernelTarget = "bzImage";
    # Currently ignored - it should be set according to 'system' once it is
    # not ignored. This is for stdenv-updates.
    kernelArch = "i386";
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
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "kirkwood_defconfig";
    kernelBaseConfig = "kirkwood_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelExtraConfig =
      ''
        BLK_DEV_RAM y
        BLK_DEV_INITRD y
        BLK_DEV_CRYPTOLOOP m
        BLK_DEV_DM m
        DM_CRYPT m
        MD y
        REISERFS_FS m
        EXT4_FS m
        USB_STORAGE_CYPRESS_ATACB m

        IP_PNP y
        NFS_FS y
        ROOT_NFS y
        TUN m
        NFS_V4 y
        NFS_V4_1 y
        NFS_FSCACHE y
        NFSD m
        NFSD_V2_ACL y
        NFSD_V3 y
        NFSD_V3_ACL y
        NFSD_V4 y

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

        FUSE_FS m
      '';
    kernelTarget = "uImage";
    uboot = "sheevaplug";
    # Only for uboot = uboot :
    ubootConfig = "sheevaplug_config";
  };

  guruplug = sheevaplug // {
    # Define `CONFIG_MACH_GURUPLUG' (see
    # <http://kerneltrap.org/mailarchive/git-commits-head/2010/5/19/33618>)
    # and other GuruPlug-specific things.  Requires the `guruplug-defconfig'
    # patch.

    kernelBaseConfig = "guruplug_defconfig";
    #kernelHeadersBaseConfig = "guruplug_defconfig";
  };

  versatileARM = {
    name = "versatileARM";
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "versatile_defconfig";
    kernelBaseConfig = "versatile_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelTarget = "zImage";
    kernelExtraConfig =
      ''
        MMC_ARMMMCI y
        #MMC_SDHCI y
        SERIO_AMBAKMI y

        AEABI y
        RTC_CLASS y
        RTC_DRV_PL031 y
        PCI y
        SCSI y
        SCSI_DMA y
        SCSI_ATA y
        BLK_DEV_SD y
        BLK_DEV_SR y
        SCSI_SYM53C8XX_2 y

        TMPFS y
        IPV6 m
        REISERFS_FS m
        EXT4_FS m

        IP_PNP y
        IP_PNP_DHCP y
        IP_PNP_BOOTP y
        ROOT_NFS y
      '';
    uboot = null;
  };

  integratorCP = {
    name = "integratorCP";
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "integrator_defconfig";
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
    uboot = "upstream";
    ubootConfig = "integratorcp_config";
  };
}
