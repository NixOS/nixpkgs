/*

  WARNING/NOTE: whenever you want to add an option here you need to
  either

  * make sure it works for all the versions in nixpkgs,
  * or check for which kernel versions it will work (using kernel
    changelog, google or whatever) and mark it with `versionOlder` or
    `versionAtLeast`

  This file has a fairly obvious structure, follow it!
  Do not duplicate predicates, sort options alphabetically, comment if
  the option's functionality is non-obvious.

  Then do test your change by building all the kernels (or at least
  their configs) in Nixpkgs or else you will guarantee lots and lots
  of pain to users trying to switch to an older kernel because of some
  hardware problems with a new one.

*/

{ stdenv, version, kernelPlatform, extraConfig, features }:

with stdenv.lib;

''
# Globally applicable

  8139TOO_8129 y
  8139TOO_PIO n # PIO is slower
  9P_FS_POSIX_ACL y
  9P_FSCACHE y
  ACCESSIBILITY y # Accessibility support
  AIC79XX_DEBUG_ENABLE n
  AIC7XXX_DEBUG_ENABLE n
  AIC94XX_DEBUG n
  ASYNC_RAID6_TEST n
  ATH9K_AHB y # Ditto, AHB bus
  ATH9K_PCI y # Detect Atheros AR9xxx cards on PCI(e) bus
  ATOMIC64_SELFTEST n
  AUXDISPLAY y # Auxiliary Display support
  B43_PHY_HT y
  BACKTRACE_SELF_TEST n
  BACKTRACE_SELF_TEST n
  BCMA_HOST_PCI y
  BINFMT_MISC y
  BINFMT_SCRIPT y # Our initrd init uses shebang scripts, so can't be modular.
  BLK_CGROUP y # required by CFQ
  BLK_DEV_INITRD y # Enable initrd support
  BLK_DEV_INTEGRITY y
  BLK_DEV_RAM y # Enable initrd support
  BLK_DEV_THROTTLING y
  BONDING m
  BRCMFMAC_USB y
  BRIDGE_VLAN_FILTERING y
  BSD_PROCESS_ACCT_V3 y
  BT_HCIUART_BCSP y
  BT_HCIUART_H4 y # UART (H4) protocol support
  BT_HCIUART_LL y
  BT_RFCOMM_TTY y # RFCOMM TTY support
  BTRFS_FS_POSIX_ACL y
  CC_OPTIMIZE_FOR_SIZE n # Optimize with -O2
  CFG80211_WEXT y # Without it, ipw2200 drivers don't build
  CFQ_GROUP_IOSCHED y
  CGROUP_DEVICE y
  CGROUPS y # used by systemd
  CIFS_ACL y
  CIFS_DFS_UPCALL y
  CIFS_FSCACHE y
  CIFS_POSIX y
  CIFS_STATS y
  CIFS_UPCALL y
  CIFS_WEAK_PW_HASH y
  CIFS_XATTR y
  CLEANCACHE y
  CLS_U32_MARK y
  CLS_U32_PERF y
  CONNECTOR y # PROC_EVENTS requires that the netlink connector is not built as a module
  CPU_FREQ_DEFAULT_GOV_PERFORMANCE y
  CRASH_DUMP n
  CRC32_SELFTEST n
  CRYPTO_TEST n
  DEBUG_DEVRES n
  DEBUG_KERNEL y
  DEBUG_STACK_USAGE n
  DEBUG_STACKOVERFLOW n
  DEFAULT_SECURITY_APPARMOR y
  DETECT_HUNG_TASK y
  DEVTMPFS y
  DONGLE y # Serial dongle support
  DRM_GMA3600 y
  DRM_GMA600 y
  DRM_LOAD_EDID_FIRMWARE y
  DVB_DYNAMIC_MINORS y # we use udev
  EFI_STUB y # EFI bootloader in the bzImage itself
  EXT2_FS_POSIX_ACL y
  EXT2_FS_SECURITY y
  EXT2_FS_XATTR y
  EXT3_FS_POSIX_ACL y
  EXT3_FS_SECURITY y
  EXT4_FS_POSIX_ACL y
  EXT4_FS_SECURITY y
  F2FS_FS m
  FANOTIFY y
  FB y
  FB_3DFX_ACCEL y
  FB_ATY_CT y # Mach64 CT/VT/GT/LT (incl. 3D RAGE) support
  FB_ATY_GX y # Mach64 GX support
  FB_EFI y
  FB_NVIDIA_I2C y # Enable DDC Support
  FB_RIVA_I2C y
  FB_SAVAGE_ACCEL y
  FB_SAVAGE_I2C y
  FB_SIS_300 y
  FB_SIS_315 y
  FB_VESA y
  FHANDLE y # used by systemd
  FRAMEBUFFER_CONSOLE y
  FRAMEBUFFER_CONSOLE_ROTATION y
  FRONTSWAP y
  FUSION y # Fusion MPT device support
  HIPPI y
  HOSTAP_FIRMWARE_NVRAM y
  HOSTAP_FIRMWARE y # Support downloading firmware images with Host AP driver
  HWMON y
  HYPERVISOR_GUEST y
  IDE n # deprecated IDE supportIRDA_ULTRA y # Ultra (connectionless) protocol
  IKCONFIG y # Make /proc/config.gz available
  IKCONFIG_PROC y # Make /proc/config.gz available
  INTEL_IDLE y
  INTERVAL_TREE_TEST n
  IOSCHED_CFQ y # Include the CFQ I/O scheduler in the kernel, rather than as a module, so that the initrd gets a good I/O scheduler
  IOSCHED_DEADLINE y
  IP_DCCP_CCID3 n # experimental
  IP_MROUTE_MULTIPLE_TABLES y
  IP_MULTICAST y
  IP_NF_TARGET_REDIRECT m
  IP_PNP n
  IP_ROUTE_VERBOSE y
  IP_VS_PROTO_AH y
  IP_VS_PROTO_ESP y
  IP_VS_PROTO_TCP y
  IP_VS_PROTO_UDP y
  IPV6_MROUTE y
  IPV6_MROUTE_MULTIPLE_TABLES y
  IPV6_MULTIPLE_TABLES y
  IPV6_OPTIMISTIC_DAD y
  IPV6_PIMSM_V2 y
  IPV6_ROUTE_INFO y
  IPV6_ROUTER_PREF y
  IPV6_SUBTREES y
  IPW2100_MONITOR y # support promiscuous mode
  IPW2200_MONITOR y # support promiscuous mode
  JFS_POSIX_ACL y
  JFS_SECURITY y
  JOYSTICK_IFORCE_232 y # I-Force Serial joysticks and wheels
  JOYSTICK_IFORCE_USB y # I-Force USB joysticks and wheels
  JOYSTICK_XPAD_FF y # X-Box gamepad rumble support
  JOYSTICK_XPAD_LEDS y # LED Support for Xbox360 controller 'BigX' LED
  KERNEL_XZ y
  KEXEC_JUMP y
  KPROBES y
  KSM y
  KVM_ASYNC_PF y
  KVM_GUEST y
  KVM_MMIO y
  L2TP_ETH m
  L2TP_IP m
  L2TP_V3 y
  LDM_PARTITION y # Windows Logical Disk Manager (Dynamic Disk) support
  LOGIRUMBLEPAD2_FF y # Logitech Rumblepad 2 force feedback
  LOGO n # not needed
  MEDIA_ATTACH y
  MEDIA_CAMERA_SUPPORT y
  MEDIA_DIGITAL_TV_SUPPORT y
  MEDIA_RC_SUPPORT y
  MEDIA_USB_SUPPORT y
  MEGARAID_NEWGEN y
  MEMCG y
  MEMCG_SWAP y
  MEMTEST y # Enable the kernel's built-in memory tester
  MICROCODE y
  MICROCODE_AMD y
  MICROCODE_INTEL y
  MMC_BLOCK_MINORS 32 # 8 is default. Modern gpt tables on eMMC may go far beyond 8.
  MOUSE_PS2_ELANTECH y # Elantech PS/2 protocol extension
  MTD_COMPLEX_MAPPINGS y # needed for many devices
  MTD_TESTS n
  MTRR_SANITIZER y
  NAMESPACES y #  Required by 'unshare' used by 'nixos-install'
  NET y
  NET_FC y # Fibre Channel driver support
  NETFILTER y
  NETFILTER_ADVANCED y
  NFS_FSCACHE y
  NFS_SWAP y
  NFS_V3_ACL y
  NFSD_V2_ACL y
  NFSD_V3 y
  NFSD_V3_ACL y
  NFSD_V4 y
  NLS y
  NLS_CODEPAGE_437 m # VFAT default for the codepage= mount option
  NLS_DEFAULT utf8
  NLS_ISO8859_1 m    # VFAT default for the iocharset= mount option
  NLS_UTF8 m
  NOTIFIER_ERROR_INJECTION n
  NUMA y
  OCFS2_DEBUG_MASKLOG n
  PARAVIRT_SPINLOCKS y
  PARAVIRT y
  PM_ADVANCED_DEBUG y
  PM_TRACE_RTC n # Disable some expensive () features
  PM_WAKELOCKS y
  POSIX_MQUEUE y
  PPP_FILTER y
  PPP_MULTILINK y # PPP multilink support
  PROC_EVENTS y
  RBTREE_TEST n
  RC_DEVICES y # Enable IR devices
  RCU_TORTURE_TEST n
  REGULATOR y # Voltage and Current Regulator Support
  REISERFS_FS_POSIX_ACL y
  REISERFS_FS_SECURITY y
  REISERFS_FS_XATTR y
  RT_GROUP_SCHED n
  RT2800USB_RT55XX y
  SCHED_AUTOGROUP y
  SCHEDSTATS n
  SCSI_LOGGING y # SCSI logging facility
  SCSI_LOWLEVEL y # enable lots of SCSI devices
  SCSI_LOWLEVEL_PCMCIA y
  SCSI_SAS_ATA y  # added to enable detection of hard drive
  SECCOMP y # used by systemd >= 231
  SECCOMP_FILTER y # ditto
  SECURITY_APPARMOR y
  SECURITY_SELINUX_BOOTPARAM_VALUE 0 # Disable SELinux by default
  SERIAL_8250 y # 8250/16550 and compatible serial support
  SLIP_COMPRESSED y # CSLIP compressed headers
  SLIP_SMART y
  SND_AC97_POWER_SAVE y # AC97 Power-Saving Mode
  SND_DYNAMIC_MINORS y
  SND_HDA_INPUT_BEEP y # Support digital beep via input layer
  SND_HDA_PATCH_LOADER y # Support configuring jack functions via fw mechanism at boot
  SND_HDA_RECONFIG y # Support reconfiguration of jack functions
  SND_USB_CAIAQ_INPUT y
  SPI y # needed for many devices
  SPI_MASTER y
  SQUASHFS_LZO y
  SQUASHFS_XATTR y
  SQUASHFS_XZ y
  SQUASHFS_ZLIB y
  STAGING y
  STANDALONE n # Support drivers that need external firmware.
  STRICT_DEVMEM y # Filter access to /dev/mem
  TEST_KSTRTOX n
  TEST_LIST_SORT n
  TEST_STRING_HELPERS n
  THERMAL_HWMON y # Hardware monitoring support
  TMPFS y
  TMPFS_POSIX_ACL y
  TRANSPARENT_HUGEPAGE_ALWAYS n
  TRANSPARENT_HUGEPAGE_MADVISE y
  TRANSPARENT_HUGEPAGE y
  UBIFS_FS_ADVANCED_COMPR y
  UDF_FS m
  UNIX y
  USB_EHCI_ROOT_HUB_TT y # Root Hub Transaction Translators
  USB_EHCI_TT_NEWSCHED y # Improved transaction translator scheduling
  USB_SERIAL_GENERIC y # USB Generic Serial Driver
  USB_SERIAL_KEYSPAN_MPR y # include firmware for various USB serial devices
  USB_SERIAL_KEYSPAN_USA18X y
  USB_SERIAL_KEYSPAN_USA19 y
  USB_SERIAL_KEYSPAN_USA19QI y
  USB_SERIAL_KEYSPAN_USA19QW y
  USB_SERIAL_KEYSPAN_USA19W y
  USB_SERIAL_KEYSPAN_USA28 y
  USB_SERIAL_KEYSPAN_USA28X y
  USB_SERIAL_KEYSPAN_USA28XA y
  USB_SERIAL_KEYSPAN_USA28XB y
  USB_SERIAL_KEYSPAN_USA49W y
  USB_SERIAL_KEYSPAN_USA49WLC y
  VGA_SWITCHEROO y # Hybrid graphics support
  VIRT_DRIVERS y
  WAN y
  X86_CHECK_BIOS_CORRUPTION y
  X86_MCE y
  XFS_POSIX_ACL y
  XFS_QUOTA y
  XFS_RT y # XFS Realtime subvolume support
  XZ_DEC_TEST n
  ZRAM m

# Architecture dependent

  ${optionalString (stdenv.isx86_64 || stdenv.isi686) ''
    XEN y
    XEN_DOM0 y
    ${optionalString ((versionAtLeast version "3.18") && (features.xen_dom0 or false))  ''
      HVC_XEN_FRONTEND y
      HVC_XEN y
      PCI_XEN y
      SWIOTLB_XEN y
      XEN_BACKEND y
      XEN_BALLOON_MEMORY_HOTPLUG y
      XEN_BALLOON y
      XEN_EFI y
      XEN_HAVE_PVMMU y
      XEN_MCE_LOG y
      XEN_PVH y
      XEN_PVHVM y
      XEN_SAVE_RESTORE y
      XEN_SCRUB_PAGES y
      XEN_SELFBALLOONING y
      XEN_STUB y
      XEN_SYS_HYPERVISOR y
      XEN_TMEM y
    ''}
  ''}

  ${optionalString (!stdenv.is64bit) ''
    HIGHMEM64G y # We need 64 GB (PAE) support for Xen guest support.
  ''}

  ${optionalString (stdenv.is64bit) ''
    IRQ_REMAP y
    VFIO_PCI_VGA y
    X86_X2APIC y
  ''}

  ${optionalString (stdenv.system == "i686-linux") ''
    FB_GEODE y
  ''}

  ${optionalString (stdenv.system == "x86_64-linux") ''
    BPF_JIT y
  ''}

  ${optionalString (stdenv.system == "x86_64-linux" || stdenv.system == "aarch64-linux") ''
    NR_CPUS 384
  ''}

# Kernel version dependent

  ${optionalString (versionAtLeast version "3.3" && versionOlder version "3.13") ''
    AUDIT_LOGINUID_IMMUTABLE y
  ''}

  ${optionalString (versionOlder version "3.10") ''
    ARM_KPROBES_TEST n
    CPU_NOTIFIER_ERROR_INJECT n
    EFI_TEST n
    RCU_PERF_TEST n
    TEST_ASYNC_DRIVER_PROBE n
    TEST_BITMAP n
    TEST_HASH n
    TEST_UUID n
    USB_SUSPEND y
  ''}

  ${optionalString (versionAtLeast version "3.10") ''
    X86_INTEL_PSTATE y
  ''}

  ${optionalString (versionAtLeast version "3.11") ''
    NFS_V4_1 y  # NFSv4.1 client support
    NFS_V4_2 y
    NFS_V4_SECURITY_LABEL y
    NFSD_V4_SECURITY_LABEL y
    PINCTRL_BAYTRAIL y # GPIO on Intel Bay Trail, for some Chromebook internal eMMC disks
    X86_INTEL_LPSS y

    ${optionalString (versionOlder version "4.4") ''
      MICROCODE_AMD_EARLY y
      MICROCODE_EARLY y
      MICROCODE_INTEL_EARLY y
    ''}
  ''}

  ${optionalString (versionAtLeast version "3.12") ''
    CEPH_FSCACHE y
    HOTPLUG_PCI_ACPI y # PCI hotplug using ACPI
    HOTPLUG_PCI_PCIE y # PCI-Expresscard hotplug support
    USER_NS y # Support for user namespaces
  ''}

  ${optionalString (versionOlder version "3.13") ''
    IPV6_PRIVACY y
  ''}

  ${optionalString (versionAtLeast version "3.13") ''
    KVM_VFIO y
    SQUASHFS_DECOMP_MULTI_PERCPU y
    SQUASHFS_FILE_DIRECT y
  ''}

  ${optionalString (versionOlder version "3.14") ''
    CC_STACKPROTECTOR y # Detect buffer overflows on the stack
  ''}

  ${optionalString (versionAtLeast version "3.14") ''
    CC_STACKPROTECTOR_REGULAR y # Detect buffer overflows on the stack
    CEPH_FS_POSIX_ACL y
  ''}

  ${optionalString (versionOlder version "3.15") ''
    USB_DEBUG n
  ''}

  ${optionalString (versionAtLeast version "3.15") ''
    UEVENT_HELPER n

    ${optionalString (versionOlder version "4.8") ''
      MLX4_EN_VXLAN y
    ''}
  ''}

  ${optionalString (versionOlder version "3.18") ''
    ZSMALLOC y
  ''}

  ${optionalString (versionAtLeast version "3.18") ''
    MODULE_COMPRESS y # Compress kernel modules for a sizable disk space savings
    MODULE_COMPRESS_XZ y
    ZSMALLOC m
  ''}

  ${optionalString (versionOlder version "3.19") ''
    PM_RUNTIME y # Power management
  ''}

  ${optionalString (versionAtLeast version "3.19") ''
    SQUASHFS_LZ4 y
  ''}

  ${optionalString (versionOlder version "4.0") ''
    EXT2_FS_XIP y # Ext2 execute in place support
  ''}

  ${optionalString (versionAtLeast version "4.0") ''
    KVM_GENERIC_DIRTYLOG_READ_PROTECT y

    ${optionalString (versionOlder version "4.6") ''
      NFSD_PNFS y
    ''}

    ${optionalString (versionOlder version "4.12") ''
      KVM_COMPAT y
    ''}
  ''}

  ${optionalString (versionOlder version "4.3" && !(features.chromiumos or false)) ''
    DRM_I915_KMS y
  ''}

  ${optionalString (versionAtLeast version "4.3") ''
    CGROUP_PIDS y
    IDLE_PAGE_TRACKING y

    ${optionalString (!features.grsecurity or false) ''
      USERFAULTFD y
    ''}
  ''}

  ${optionalString (versionOlder version "4.4") ''
    B43_PCMCIA y
  ''}

  ${optionalString (versionAtLeast version "4.4") ''
    BPF_SYSCALL y
    BRCMFMAC_PCIE y
    F2FS_FS_ENCRYPTION y
    F2FS_FS_SECURITY y
    FW_LOADER_USER_HELPER_FALLBACK n
    GLOB_SELFTEST n
    KEXEC_FILE y
    LNET_SELFTEST n
    LOCK_TORTURE_TEST n
    NET_ACT_BPF m
    NET_CLS_BPF m
    NET_FOU_IP_TUNNELS y
    NET_L3_MASTER_DEV y
    PERCPU_TEST n
    TEST_BPF n
    TEST_FIRMWARE n
    TEST_HEXDUMP n
    TEST_PRINTF n
    TEST_RHASHTABLE n
    TEST_STATIC_KEYS n
    TEST_UDELAY n
    TEST_USER_COPY n
    ZBUD y
    ZSWAP y

    ${optionalString (versionOlder version "4.13") ''
      TEST_LKM n
    ''}

    ${optionalString (!features.grsecurity or false) ''
      BPF_EVENTS y
      RANDOMIZE_BASE y
    ''}
  ''}

  ${optionalString (versionAtLeast version "4.5" && (versionOlder version "4.9")) ''
    DRM_AMD_POWERPLAY y # necessary for amdgpu polaris support
  ''}

  ${optionalString (versionOlder version "4.7") ''
    DEVPTS_MULTIPLE_INSTANCES y # Linux containers
  ''}

  ${optionalString (versionAtLeast version "4.7") ''
    IPV6_FOU_TUNNEL m
  ''}

  ${optionalString (versionOlder version "4.8") ''
    KVM_APIC_ARCHITECTURE y

    ${optionalString (versionAtLeast version "4.4") ''
      EXT4_ENCRYPTION m
    ''}
  ''}

  ${optionalString (versionAtLeast version "4.8") ''
    EXT4_ENCRYPTION y
  ''}

  ${optionalString (versionAtLeast version "4.9") ''
    DRM_AMDGPU_CIK y # (stable) amdgpu support for bonaire and newer chipsets
    DRM_AMDGPU_SI y # (experimental) amdgpu support for verde and newer chipsets
    FS_ENCRYPTION m
    MODVERSIONS y
  ''}

  ${optionalString (versionOlder version "4.11") ''
    DEBUG_NX_TEST n
    TIMER_STATS y
    UPROBE_EVENT y

    ${optionalString (!features.grsecurity or false) ''
      DEBUG_SET_MODULE_RONX y # Detect writes to read-only module pages
    ''}
  ''}

  ${optionalString (versionAtLeast version "4.11") ''
    DRM_DEBUG_MM_SELFTEST n
    MQ_IOSCHED_DEADLINE y
    TEST_PARMAN n
    TEST_SORT n
    UPROBE_EVENTS y
    WW_MUTEX_SELFTEST n
  ''}

  ${optionalString (versionOlder version "4.12") ''
    KVM_DEVICE_ASSIGNMENT y
    PSS_MIXER y # Enable PSS mixer (Beethoven ADSP-16 and other compatible)
  ''}

  ${optionalString (versionAtLeast version "4.12") ''
    IOSCHED_BFQ m
    MQ_IOSCHED_KYBER y
  ''}

  ${optionalString (versionOlder version "4.13") ''
    CIFS_SMB2 y
  ''}

  ${optionalString (versionAtLeast version "4.13") ''
    TEST_LKM m
  ''}

# Feature dependent

  ${optionalString (!features.grsecurity or false) ''
    DEVKMEM n # Disable /dev/kmem
    DYNAMIC_DEBUG y
    FTRACE y
    FTRACE_SYSCALLS y
    FUNCTION_PROFILER y
    FUNCTION_TRACER y
    RING_BUFFER_BENCHMARK n
    SCHED_TRACER y
    SECURITY_YAMA y # Prevent processes from ptracing non-children processes
    STACK_TRACER y
    SUNRPC_DEBUG y # Easier debugging of NFS issues
  ''}

  ${optionalString (!(features.chromiumos or false)) ''
    MEDIA_PCI_SUPPORT y
  ''}

  # ChromiumOS support
  ${optionalString (features.chromiumos or false) ''
    ANDROID_PARANOID_NETWORK n
    BLK_DEV_DM y
    CHARGER_CROS_USB_PD y
    CHROME_PLATFORMS y
    CPU_FREQ_GOV_INTERACTIVE n
    CPU_FREQ_STAT y
    DM_BOOTCACHE n
    DM_VERITY n
    DRM_VGEM n
    I2C y
    INPUT_KEYRESET n
    IPV6 y
    IPV6_VTI n
    MEDIA_SUBDRV_AUTOSELECT n
    MFD_CROS_EC y
    MFD_CROS_EC_DEV y
    MFD_CROS_EC_LPC y
    MMC_SDHCI_PXAV2 n
    NET_IPVTI n
    REGULATOR_FIXED_VOLTAGE n
    TPS6105X n
    UID_CPUTIME n
    VGA_SWITCHEROO n
    VIDEO_IR_I2C n

    ${optionalString (versionAtLeast version "3.18") ''
      BCMDHD n
      CHROMEOS_OF_FIRMWARE y
      CPUFREQ_DT n
      DRM_POWERVR_ROGUE n
      EXTCON_CROS_EC n
      TEST_RHASHTABLE n
      TRUSTY n
    ''}

    ${optionalString (versionOlder version "3.18") ''
      DVB_USB_AF9015 n
      DVB_USB_AF9035 n
      DVB_USB_ANYSEE n
      DVB_USB_AZ6007 n
      DVB_USB_DIB0700 n
      DVB_USB_DW2102 n
      DVB_USB_IT913X n
      DVB_USB_LME2510 n
      DVB_USB_PCTV452E n
      DVB_USB_RTL28XXU n
      DVB_USB_TTUSB2 n
      MALI_MIDGARD n
      SPEAKUP n
      USB_DWC2 n
      USB_GADGET n
      USB_GSPCA n
      USB_S2255 n
      VIDEO_EM28XX n
      VIDEO_TM6000 n
      XO15_EBOOK n
    ''}
  ''}

# Extra configuration

  ${kernelPlatform.kernelExtraConfig or ""}
  ${extraConfig}
''
