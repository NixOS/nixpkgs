args @ { stdenv, fetchurl, userModeLinux ? false, extraConfig ? "", ... }:

import ./generic.nix (

  rec {
    version = "2.6.27.41";
  
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v2.6/linux-${version}.tar.bz2";
      sha256 = "1a26yycbry64214pf1z96rz3jyrylqh0barsdsw7m1x15v7s6gn8";
    };

    features.iwlwifi = true;

    config =
      ''
        # Don't include any debug features.
        DEBUG_KERNEL n

        # Support drivers that need external firmware.
        STANDALONE n

        # Make /proc/config.gz available.
        IKCONFIG_PROC y

        # Optimize with -O2, not -Os.
        CC_OPTIMIZE_FOR_SIZE n

        # Virtualisation (KVM, Xen...).
        PARAVIRT_GUEST y
        KVM_CLOCK y
        KVM_GUEST y
        XEN y

        # We need 64 GB (PAE) support for Xen guest support.
        HIGHMEM64G? y

        # Enable the kernel's built-in memory tester.
        MEMTEST y

        # Include the CFQ I/O scheduler in the kernel, rather than as a
        # module, so that the initrd gets a good I/O scheduler.
        IOSCHED_CFQ y

        # Disable some expensive (?) features.
        MARKERS n
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
        IWLWIFI_RFKILL y
        IWLAGN_SPECTRUM_MEASUREMENT y
        IWLAGN_LEDS y
        IWL4965 y # Intel Wireless WiFi 4965AGN
        IWL5000 y # Intel Wireless WiFi 5000AGN
        IWL3945_RFKILL y
        IWL3945_LEDS y
        HOSTAP_FIRMWARE y # Support downloading firmware images with Host AP driver
        HOSTAP_FIRMWARE_NVRAM y

        # Some settings to make sure that fbcondecor works - in particular,
        # disable tileblitting and the drivers that need it.

        # Enable various FB devices.
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
        FB_TRIDENT_ACCEL y
        FB_GEODE y

        # Sound.
        SND_AC97_POWER_SAVE y # AC97 Power-Saving Mode
        SND_USB_CAIAQ_INPUT y
        PSS_MIXER y # Enable PSS mixer (Beethoven ADSP-16 and other compatible)

        # Enable a bunch of USB storage devices.
        USB_STORAGE_DATAFAB y
        USB_STORAGE_FREECOM y
        USB_STORAGE_ISD200 y
        USB_STORAGE_USBAT y
        USB_STORAGE_SDDR09 y
        USB_STORAGE_SDDR55 y
        USB_STORAGE_JUMPSHOT y
        USB_STORAGE_ONETOUCH y
        USB_STORAGE_KARMA y
        USB_STORAGE_CYPRESS_ATACB y

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
        REISERFS_FS_XATTR y
        REISERFS_FS_POSIX_ACL y
        REISERFS_FS_SECURITY y
        JFS_POSIX_ACL y
        JFS_SECURITY y
        XFS_QUOTA y
        XFS_POSIX_ACL y
        XFS_RT y # XFS Realtime subvolume support
        OCFS2_DEBUG_MASKLOG n
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
        BLK_DEV_IO_TRACE n
        BSD_PROCESS_ACCT_V3 y
        BT_HCIUART_BCSP y
        BT_HCIUART_H4 y # UART (H4) protocol support
        BT_HCIUART_LL y
        BT_RFCOMM_TTY y # RFCOMM TTY support
        CPU_FREQ_DEBUG n
        CRASH_DUMP n
        DMAR? n # experimental
        FUSION y # Fusion MPT device support
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
        MODVERSIONS y
        MTRR_SANITIZER y
        NET_FC y # Fibre Channel driver support
        PCI_LEGACY y
        PPP_MULTILINK y # PPP multilink support
        SCSI_LOGGING y # SCSI logging facility
        SERIAL_8250 y # 8250/16550 and compatible serial support
        SLIP_COMPRESSED y # CSLIP compressed headers
        SLIP_SMART y
        THERMAL_HWMON y # Hardware monitoring support
        USB_DEBUG n
        USB_EHCI_ROOT_HUB_TT y # Root Hub Transaction Translators
        X86_MCE y

        ${extraConfig}
      '';
  }

  // args
)
