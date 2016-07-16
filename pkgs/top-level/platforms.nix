rec {
  pcBase = {
    name = "pc";
    uboot = null;
    kernelHeadersBaseConfig = "defconfig";
    kernelBaseConfig = "defconfig";
    # Build whatever possible as a module, if not stated in the extra config.
    kernelAutoModules = true;
    kernelTarget = "bzImage";
  };

  pc64 = pcBase // { kernelArch = "x86_64"; };

  pc32 = pcBase // { kernelArch = "i386"; };

  pc32_simplekernel = pc32 // {
    kernelAutoModules = false;
  };

  pc64_simplekernel = pc64 // {
    kernelAutoModules = false;
  };

  sheevaplug = {
    name = "sheevaplug";
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "multi_v5_defconfig";
    kernelBaseConfig = "multi_v5_defconfig";
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
        BTRFS_FS m
        XFS_FS m
        JFS_FS m
        EXT4_FS m
        USB_STORAGE_CYPRESS_ATACB m

        # mv cesa requires this sw fallback, for mv-sha1
        CRYPTO_SHA1 y
        # Fast crypto
        CRYPTO_TWOFISH y
        CRYPTO_TWOFISH_COMMON y
        CRYPTO_BLOWFISH y
        CRYPTO_BLOWFISH_COMMON y

        IP_PNP y
        IP_PNP_DHCP y
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
        NETFILTER y
        IP_NF_IPTABLES y
        IP_NF_FILTER y
        IP_NF_MATCH_ADDRTYPE y
        IP_NF_TARGET_LOG y
        IP_NF_MANGLE y
        IPV6 m
        VLAN_8021Q m

        CIFS y
        CIFS_XATTR y
        CIFS_POSIX y
        CIFS_FSCACHE y
        CIFS_ACL y

        WATCHDOG y
        WATCHDOG_CORE y
        ORION_WATCHDOG m

        ZRAM m
        NETCONSOLE m

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

        # systemd uses cgroups
        CGROUPS y

        # Latencytop 
        LATENCYTOP y

        # Ubi for the mtd
        MTD_UBI y
        UBIFS_FS y
        UBIFS_FS_XATTR y
        UBIFS_FS_ADVANCED_COMPR y
        UBIFS_FS_LZO y
        UBIFS_FS_ZLIB y
        UBIFS_FS_DEBUG n

        # Kdb, for kernel troubles
        KGDB y
        KGDB_SERIAL_CONSOLE y
        KGDB_KDB y
      '';
    kernelMakeFlags = [ "LOADADDR=0x0200000" ];
    kernelTarget = "uImage";
    uboot = "sheevaplug";
    # Only for uboot = uboot :
    ubootConfig = "sheevaplug_config";
    kernelDTB = true; # Beyond 3.10
    gcc = {
      arch = "armv5te";
      float = "soft";
    };
  };

  raspberrypi = {
    name = "raspberrypi";
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "bcm2835_defconfig";
    kernelBaseConfig = "bcmrpi_defconfig";
    kernelDTB = true;
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
        BTRFS_FS y
        XFS_FS m
        JFS_FS y
        EXT4_FS y

        IP_PNP y
        IP_PNP_DHCP y
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
        NETFILTER y
        IP_NF_IPTABLES y
        IP_NF_FILTER y
        IP_NF_MATCH_ADDRTYPE y
        IP_NF_TARGET_LOG y
        IP_NF_MANGLE y
        IPV6 m
        VLAN_8021Q m

        CIFS y
        CIFS_XATTR y
        CIFS_POSIX y
        CIFS_FSCACHE y
        CIFS_ACL y

        ZRAM m

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

        # nixos mounts some cgroup
        CGROUPS y

        # Latencytop 
        LATENCYTOP y
      '';
    kernelTarget = "zImage";
    uboot = null;
    gcc = {
      arch = "armv6";
      fpu = "vfp";
      float = "hard";
    };
  };

  raspberrypi2 = armv7l-hf-multiplatform // {
    name = "raspberrypi2";
    kernelBaseConfig = "bcm2709_defconfig";
    kernelDTB = true;
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
        BTRFS_FS y
        XFS_FS m
        JFS_FS y
        EXT4_FS y

        IP_PNP y
        IP_PNP_DHCP y
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
        NETFILTER y
        IP_NF_IPTABLES y
        IP_NF_FILTER y
        IP_NF_MATCH_ADDRTYPE y
        IP_NF_TARGET_LOG y
        IP_NF_MANGLE y
        IPV6 m
        VLAN_8021Q m

        CIFS y
        CIFS_XATTR y
        CIFS_POSIX y
        CIFS_FSCACHE y
        CIFS_ACL y

        ZRAM m

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

        # nixos mounts some cgroup
        CGROUPS y

        # Latencytop 
        LATENCYTOP y

        # Disable the common config Xen, it doesn't build on ARM
	XEN? n
      '';
    kernelTarget = "zImage";
    uboot = null;
  };

  guruplug = sheevaplug // {
    # Define `CONFIG_MACH_GURUPLUG' (see
    # <http://kerneltrap.org/mailarchive/git-commits-head/2010/5/19/33618>)
    # and other GuruPlug-specific things.  Requires the `guruplug-defconfig'
    # patch.

    kernelBaseConfig = "guruplug_defconfig";
    #kernelHeadersBaseConfig = "guruplug_defconfig";
  };

  fuloong2f_n32 = {
    name = "fuloong2f_n32";
    kernelMajor = "2.6";
    kernelHeadersBaseConfig = "fuloong2e_defconfig";
    kernelBaseConfig = "lemote2f_defconfig";
    kernelArch = "mips";
    kernelAutoModules = false;
    kernelExtraConfig =
      ''
        MIGRATION n
        COMPACTION n

        # nixos mounts some cgroup
        CGROUPS y

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
        IP_PNP_DHCP y
        IP_PNP_BOOTP y
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

        # Needed for udev >= 150
        SYSFS_DEPRECATED_V2 n

        VGA_CONSOLE n
        VT_HW_CONSOLE_BINDING y
        SERIAL_8250_CONSOLE y
        FRAMEBUFFER_CONSOLE y
        EXT2_FS y
        EXT3_FS y
        REISERFS_FS y
        MAGIC_SYSRQ y

        # The kernel doesn't boot at all, with FTRACE
        FTRACE n
      '';
    kernelTarget = "vmlinux";
    uboot = null;
    gcc.arch = "loongson2f";
  };
  
  beaglebone = armv7l-hf-multiplatform // {
    name = "beaglebone";
    kernelBaseConfig = "omap2plus_defconfig";
    kernelAutoModules = false;
    kernelExtraConfig = ""; # TBD kernel config
    kernelTarget = "zImage";
    uboot = null;
  };

  armv7l-hf-multiplatform = {
    name = "armv7l-hf-multiplatform";
    kernelMajor = "2.6"; # Using "2.6" enables 2.6 kernel syscalls in glibc.
    kernelHeadersBaseConfig = "multi_v7_defconfig";
    kernelBaseConfig = "multi_v7_defconfig";
    kernelArch = "arm";
    kernelDTB = true;
    kernelAutoModules = false;
    uboot = null;
    kernelTarget = "zImage";
    kernelExtraConfig = ''
      AHCI_IMX y
    '';
    gcc = {
      # Some table about fpu flags:
      # http://community.arm.com/servlet/JiveServlet/showImage/38-1981-3827/blogentry-103749-004812900+1365712953_thumb.png
      # Cortex-A5: -mfpu=neon-fp16
      # Cortex-A7 (rpi2): -mfpu=neon-vfpv4
      # Cortex-A8 (beaglebone): -mfpu=neon
      # Cortex-A9: -mfpu=neon-fp16
      # Cortex-A15: -mfpu=neon-vfpv4

      # More about FPU:
      # https://wiki.debian.org/ArmHardFloatPort/VfpComparison

      # vfpv3-d16 is what Debian uses and seems to be the best compromise: NEON is not supported in e.g. Scaleway or Tegra 2,
      # and the above page suggests NEON is only an improvement with hand-written assembly.
      arch = "armv7-a";
      fpu = "vfpv3-d16";
      float = "hard";

      # For Raspberry Pi the 2 the best would be:
      #   cpu = "cortex-a7";
      #   fpu = "neon-vfpv4";
    };
  };

}
