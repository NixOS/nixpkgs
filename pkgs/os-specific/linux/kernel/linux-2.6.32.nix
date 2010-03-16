args @ { stdenv, fetchurl, userModeLinux ? false, extraConfig ? ""
, ... }:

let
  configWithPlatform = kernelPlatform :
    ''
      # Don't include any debug features.
      DEBUG_KERNEL n

      # Support drivers that need external firmware.
      STANDALONE n

      # Make /proc/config.gz available.
      IKCONFIG_PROC y

      # Optimize with -O2, not -Os.
      CC_OPTIMIZE_FOR_SIZE n

      # Enable the kernel's built-in memory tester.
      MEMTEST y

      # Include the CFQ I/O scheduler in the kernel, rather than as a
      # module, so that the initrd gets a good I/O scheduler.
      IOSCHED_CFQ y

      # Disable some expensive (?) features.
      FTRACE n
      KPROBES n
      NUMA? n
      PM_TRACE_RTC n

      # Enable various subsystems.
      ACCESSIBILITY y # Accessibility support
      AUXDISPLAY y # Auxiliary Display support
      DONGLE y # Serial dongle support
      HIPPI y
      MTD_COMPLEX_MAPPINGS y # needed for many devices
      NET_POCKET y # enable pocket and portable adapters
      SCSI_LOWLEVEL y # enable lots of SCSI devices
      SCSI_LOWLEVEL_PCMCIA y
      SPI y # needed for many devices
      SPI_MASTER y
      WAN y

      # Networking options.
      IP_PNP n
      IPV6_PRIVACY y
      NETFILTER_ADVANCED y
      IP_VS_PROTO_TCP y
      IP_VS_PROTO_UDP y
      IP_VS_PROTO_ESP y
      IP_VS_PROTO_AH y
      IP_DCCP_CCID3 n # experimental
      CLS_U32_PERF y
      CLS_U32_MARK y

      # Wireless networking.
      IPW2100_MONITOR y # support promiscuous mode
      IPW2200_MONITOR y # support promiscuous mode
      IWLWIFI_LEDS? y
      IWLWIFI_SPECTRUM_MEASUREMENT y
      IWL3945_SPECTRUM_MEASUREMENT y
      IWL4965 y # Intel Wireless WiFi 4965AGN
      IWL5000 y # Intel Wireless WiFi 5000AGN
      HOSTAP_FIRMWARE y # Support downloading firmware images with Host AP driver
      HOSTAP_FIRMWARE_NVRAM y

      # Some settings to make sure that fbcondecor works - in particular,
      # disable tileblitting and the drivers that need it.

      # Enable various FB devices.
      FB y
      FB_EFI y
      FB_NVIDIA_I2C y # Enable DDC Support
      FB_RIVA_I2C y
      FB_ATY_CT y # Mach64 CT/VT/GT/LT (incl. 3D RAGE) support
      FB_ATY_GX y # Mach64 GX support
      FB_SAVAGE_I2C y
      FB_SAVAGE_ACCEL y
      FB_SIS_300 y
      FB_SIS_315 y
      FB_3DFX_ACCEL y
      FB_GEODE y

      # Video configuration
      # The intel drivers already require KMS
      DRM_I915_KMS y

      # Sound.
      SND_AC97_POWER_SAVE y # AC97 Power-Saving Mode
      SND_HDA_INPUT_BEEP y # Support digital beep via input layer
      SND_USB_CAIAQ_INPUT y
      PSS_MIXER y # Enable PSS mixer (Beethoven ADSP-16 and other compatible)

      # USB serial devices.
      USB_SERIAL_GENERIC y # USB Generic Serial Driver
      USB_SERIAL_KEYSPAN_MPR y # include firmware for various USB serial devices
      USB_SERIAL_KEYSPAN_USA28 y
      USB_SERIAL_KEYSPAN_USA28X y
      USB_SERIAL_KEYSPAN_USA28XA y
      USB_SERIAL_KEYSPAN_USA28XB y
      USB_SERIAL_KEYSPAN_USA19 y
      USB_SERIAL_KEYSPAN_USA18X y
      USB_SERIAL_KEYSPAN_USA19W y
      USB_SERIAL_KEYSPAN_USA19QW y
      USB_SERIAL_KEYSPAN_USA19QI y
      USB_SERIAL_KEYSPAN_USA49W y
      USB_SERIAL_KEYSPAN_USA49WLC y

      # Filesystem options - in particular, enable extended attributes and
      # ACLs for all filesystems that support them.
      EXT2_FS_XATTR y # Ext2 extended attributes
      EXT2_FS_POSIX_ACL y # Ext2 POSIX Access Control Lists
      EXT2_FS_SECURITY y # Ext2 Security Labels
      EXT2_FS_XIP y # Ext2 execute in place support
      EXT4_FS_POSIX_ACL y
      EXT4_FS_SECURITY y
      REISERFS_FS_XATTR y
      REISERFS_FS_POSIX_ACL y
      REISERFS_FS_SECURITY y
      JFS_POSIX_ACL y
      JFS_SECURITY y
      XFS_QUOTA y
      XFS_POSIX_ACL y
      XFS_RT y # XFS Realtime subvolume support
      OCFS2_DEBUG_MASKLOG n
      OCFS2_FS_POSIX_ACL y
      BTRFS_FS_POSIX_ACL y
      UBIFS_FS_XATTR y
      UBIFS_FS_ADVANCED_COMPR y
      NFSD_V2_ACL y
      NFSD_V3 y
      NFSD_V3_ACL y
      NFSD_V4 y
      CIFS_XATTR y
      CIFS_POSIX y

      # Security related features.
      STRICT_DEVMEM y # Filter access to /dev/mem
      SECURITY_SELINUX_BOOTPARAM_VALUE 0 # disable SELinux by default

      # Misc. options.
      8139TOO_8129 y
      8139TOO_PIO n # PIO is slower
      AIC79XX_DEBUG_ENABLE n
      AIC7XXX_DEBUG_ENABLE n
      AIC94XX_DEBUG n
      B43_PCMCIA y
      BLK_DEV_BSG n
      BLK_DEV_CMD640_ENHANCED y # CMD640 enhanced support
      BLK_DEV_IDEACPI y # IDE ACPI support
      BLK_DEV_INTEGRITY y
      BSD_PROCESS_ACCT_V3 y
      BT_HCIUART_BCSP y
      BT_HCIUART_H4 y # UART (H4) protocol support
      BT_HCIUART_LL y
      BT_RFCOMM_TTY y # RFCOMM TTY support
      CPU_FREQ_DEBUG n
      CRASH_DUMP n
      DMAR? n # experimental
      DVB_DYNAMIC_MINORS y # we use udev
      FUSION y # Fusion MPT device support
      IDE_GD_ATAPI y # ATAPI floppy support
      IRDA_ULTRA y # Ultra (connectionless) protocol
      JOYSTICK_IFORCE_232 y # I-Force Serial joysticks and wheels
      JOYSTICK_IFORCE_USB y # I-Force USB joysticks and wheels
      JOYSTICK_XPAD_FF y # X-Box gamepad rumble support
      JOYSTICK_XPAD_LEDS y # LED Support for Xbox360 controller 'BigX' LED
      KALLSYMS_EXTRA_PASS n
      LDM_PARTITION y # Windows Logical Disk Manager (Dynamic Disk) support
      LEDS_TRIGGER_IDE_DISK y # LED IDE Disk Trigger
      LOGIRUMBLEPAD2_FF y # Logitech Rumblepad 2 force feedback
      LOGO n # not needed
      MEDIA_ATTACH y
      MEGARAID_NEWGEN y
      MICROCODE_AMD y
      MODVERSIONS y
      MOUSE_PS2_ELANTECH y # Elantech PS/2 protocol extension
      MTRR_SANITIZER y
      NET_FC y # Fibre Channel driver support
      PCI_LEGACY y
      PPP_MULTILINK y # PPP multilink support
      REGULATOR y # Voltage and Current Regulator Support
      SCSI_LOGGING y # SCSI logging facility
      SERIAL_8250 y # 8250/16550 and compatible serial support
      SLIP_COMPRESSED y # CSLIP compressed headers
      SLIP_SMART y
      THERMAL_HWMON y # Hardware monitoring support
      USB_DEBUG n
      USB_EHCI_ROOT_HUB_TT y # Root Hub Transaction Translators
      X86_CHECK_BIOS_CORRUPTION y
      X86_MCE y

      ${if kernelPlatform ? kernelExtraConfig then kernelPlatform.kernelExtraConfig else ""}
      ${extraConfig}
    '';
in

import ./generic.nix (

  rec {
    version = "2.6.32.10";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "04d8rwvpv0hy0il3wzk2yc7ah72jkdxnym7h7k3ib0csjhfvh2y9";
    };

    config = configWithPlatform stdenv.platform;
    configCross = configWithPlatform stdenv.cross.platform;

    features.iwlwifi = true;
  }

  // removeAttrs args ["extraConfig"]
)
