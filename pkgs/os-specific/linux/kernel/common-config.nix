/*

  WARNING/NOTE: whenever you want to add an option here you need to
  either

  * mark it as an optional one with `?` suffix,
  * or make sure it works for all the versions in nixpkgs,
  * or check for which kernel versions it will work (using kernel
    changelog, google or whatever) and mark it with `versionOlder` or
    `versionAtLeast`.

  Then do test your change by building all the kernels (or at least
  their configs) in Nixpkgs or else you will guarantee lots and lots
  of pain to users trying to switch to an older kernel because of some
  hardware problems with a new one.

*/

{ stdenv, version, extraConfig, features }:

with stdenv.lib;

''
  # Compress kernel modules for a sizable disk space savings.
  ${optionalString (versionAtLeast version "3.18") ''
    MODULE_COMPRESS y
    MODULE_COMPRESS_XZ y
  ''}

  KERNEL_XZ y

  # Debugging.
  DEBUG_KERNEL y
  DYNAMIC_DEBUG y
  BACKTRACE_SELF_TEST n
  DEBUG_DEVRES n
  DEBUG_STACK_USAGE n
  DEBUG_STACKOVERFLOW n
  SCHEDSTATS n
  DETECT_HUNG_TASK y
  DEBUG_INFO n # Not until we implement a separate debug output

  ${optionalString (versionOlder version "4.4") ''
    CPU_NOTIFIER_ERROR_INJECT? n
  ''}

  ${optionalString (versionOlder version "4.11") ''
    TIMER_STATS y
    DEBUG_NX_TEST n
  ''}

  # Bump the maximum number of CPUs to support systems like EC2 x1.*
  # instances and Xeon Phi.
  ${optionalString (stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "aarch64-linux") ''
    NR_CPUS 384
  ''}

  # Unix domain sockets.
  UNIX y

  # Power management.
  ${optionalString (versionOlder version "3.19") ''
    PM_RUNTIME y
  ''}
  PM_ADVANCED_DEBUG y
  ${optionalString (versionAtLeast version "3.11") ''
    X86_INTEL_LPSS y
  ''}
  ${optionalString (versionAtLeast version "3.10") ''
    X86_INTEL_PSTATE y
  ''}
  INTEL_IDLE y
  CPU_FREQ_DEFAULT_GOV_PERFORMANCE y
  ${optionalString (versionOlder version "3.10") ''
    USB_SUSPEND y
  ''}
  PM_WAKELOCKS y

  # Support drivers that need external firmware.
  STANDALONE n

  # Make /proc/config.gz available.
  IKCONFIG y
  IKCONFIG_PROC y

  # Optimize with -O2, not -Os.
  CC_OPTIMIZE_FOR_SIZE n

  # Enable the kernel's built-in memory tester.
  MEMTEST y

  # Include the CFQ I/O scheduler in the kernel, rather than as a
  # module, so that the initrd gets a good I/O scheduler.
  IOSCHED_CFQ y
  BLK_CGROUP y # required by CFQ
  IOSCHED_DEADLINE y
  ${optionalString (versionAtLeast version "4.11") ''
    MQ_IOSCHED_DEADLINE y
  ''}
  ${optionalString (versionAtLeast version "4.12") ''
    BFQ_GROUP_IOSCHED y
    MQ_IOSCHED_KYBER y
    IOSCHED_BFQ m
  ''}

  # Enable NUMA.
  NUMA? y

  # Disable some expensive (?) features.
  PM_TRACE_RTC n

  # Enable initrd support.
  BLK_DEV_RAM y
  BLK_DEV_INITRD y

  # Enable various subsystems.
  ACCESSIBILITY y # Accessibility support
  AUXDISPLAY y # Auxiliary Display support
  DONGLE y # Serial dongle support
  HIPPI y
  MTD_COMPLEX_MAPPINGS y # needed for many devices
  SCSI_LOWLEVEL y # enable lots of SCSI devices
  SCSI_LOWLEVEL_PCMCIA y
  SCSI_SAS_ATA y  # added to enable detection of hard drive
  SPI y # needed for many devices
  SPI_MASTER y
  WAN y

  # Networking options.
  NET y
  IP_PNP n
  ${optionalString (versionOlder version "3.13") ''
    IPV6_PRIVACY y
  ''}
  NETFILTER y
  NETFILTER_ADVANCED y
  CGROUP_BPF? y # Required by systemd per-cgroup firewalling
  IP_ROUTE_VERBOSE y
  IP_MROUTE_MULTIPLE_TABLES y
  IP_VS_PROTO_TCP y
  IP_VS_PROTO_UDP y
  IP_VS_PROTO_ESP y
  IP_VS_PROTO_AH y
  IP_DCCP_CCID3 n # experimental
  IP_MULTICAST y
  IPV6_ROUTER_PREF y
  IPV6_ROUTE_INFO y
  IPV6_OPTIMISTIC_DAD y
  IPV6_MULTIPLE_TABLES y
  IPV6_SUBTREES y
  IPV6_MROUTE y
  IPV6_MROUTE_MULTIPLE_TABLES y
  IPV6_PIMSM_V2 y
  ${optionalString (versionAtLeast version "4.7") ''
    IPV6_FOU_TUNNEL m
  ''}
  CLS_U32_PERF y
  CLS_U32_MARK y
  ${optionalString (stdenv.system == "x86_64-linux") ''
    BPF_JIT y
  ''}
  ${optionalString (versionAtLeast version "4.4") ''
    NET_CLS_BPF m
    NET_ACT_BPF m
  ''}
  L2TP_V3 y
  L2TP_IP m
  L2TP_ETH m
  BRIDGE_VLAN_FILTERING y
  BONDING m
  NET_L3_MASTER_DEV? y
  NET_FOU_IP_TUNNELS? y
  IP_NF_TARGET_REDIRECT m

  # Wireless networking.
  CFG80211_WEXT? y # Without it, ipw2200 drivers don't build
  IPW2100_MONITOR? y # support promiscuous mode
  IPW2200_MONITOR? y # support promiscuous mode
  HOSTAP_FIRMWARE? y # Support downloading firmware images with Host AP driver
  HOSTAP_FIRMWARE_NVRAM? y
  ATH9K_PCI? y # Detect Atheros AR9xxx cards on PCI(e) bus
  ATH9K_AHB? y # Ditto, AHB bus
  B43_PHY_HT? y
  BCMA_HOST_PCI? y

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
  FB_VESA y
  FRAMEBUFFER_CONSOLE y
  FRAMEBUFFER_CONSOLE_ROTATION y
  ${optionalString (stdenv.system == "i686-linux") ''
    FB_GEODE y
  ''}

  # Video configuration.
  # Enable KMS for devices whose X.org driver supports it.
  ${optionalString (versionOlder version "4.3") ''
    DRM_I915_KMS y
  ''}
  # Allow specifying custom EDID on the kernel command line
  DRM_LOAD_EDID_FIRMWARE y
  VGA_SWITCHEROO y # Hybrid graphics support
  DRM_GMA600 y
  DRM_GMA3600 y
  ${optionalString (versionAtLeast version "4.5" && (versionOlder version "4.9")) ''
    DRM_AMD_POWERPLAY y # necessary for amdgpu polaris support
  ''}
  ${optionalString (versionAtLeast version "4.9") ''
    DRM_AMDGPU_SI y # (experimental) amdgpu support for verde and newer chipsets
    DRM_AMDGPU_CIK y # (stable) amdgpu support for bonaire and newer chipsets
  ''}

  # Sound.
  SND_DYNAMIC_MINORS y
  SND_AC97_POWER_SAVE y # AC97 Power-Saving Mode
  SND_HDA_INPUT_BEEP y # Support digital beep via input layer
  SND_HDA_RECONFIG y # Support reconfiguration of jack functions
  SND_HDA_PATCH_LOADER y # Support configuring jack functions via fw mechanism at boot
  SND_USB_CAIAQ_INPUT y
  ${optionalString (versionOlder version "4.12") ''
    PSS_MIXER y # Enable PSS mixer (Beethoven ADSP-16 and other compatible)
  ''}

  # USB serial devices.
  USB_SERIAL_GENERIC y # USB Generic Serial Driver

  # Include firmware for various USB serial devices.
  # Only applicable for kernels below 4.16, after that no firmware is shipped in the kernel tree.
  ${optionalString (versionOlder version "4.16") ''
    USB_SERIAL_KEYSPAN_MPR y
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
  ''}

  # Device mapper (RAID, LVM, etc.)
  MD y

  # Filesystem options - in particular, enable extended attributes and
  # ACLs for all filesystems that support them.
  FANOTIFY y
  TMPFS y
  TMPFS_POSIX_ACL y
  ${optionalString (versionAtLeast version "4.9") ''
    FS_ENCRYPTION? m
  ''}
  EXT2_FS_XATTR y
  EXT2_FS_POSIX_ACL y
  EXT2_FS_SECURITY y
  ${optionalString (versionOlder version "4.0") ''
    EXT2_FS_XIP y # Ext2 execute in place support
  ''}
  EXT3_FS_POSIX_ACL y
  EXT3_FS_SECURITY y
  EXT4_FS_POSIX_ACL y
  EXT4_ENCRYPTION? ${if versionOlder version "4.8" then "m" else "y"}
  EXT4_FS_SECURITY y
  REISERFS_FS_XATTR? y
  REISERFS_FS_POSIX_ACL? y
  REISERFS_FS_SECURITY? y
  JFS_POSIX_ACL? y
  JFS_SECURITY? y
  XFS_QUOTA? y
  XFS_POSIX_ACL? y
  XFS_RT? y # XFS Realtime subvolume support
  OCFS2_DEBUG_MASKLOG? n
  BTRFS_FS_POSIX_ACL y
  UBIFS_FS_ADVANCED_COMPR? y
  F2FS_FS m
  F2FS_FS_SECURITY? y
  F2FS_FS_ENCRYPTION? y
  UDF_FS m
  ${optionalString (versionAtLeast version "4.0" && versionOlder version "4.6") ''
    NFSD_PNFS y
  ''}
  NFSD_V2_ACL y
  NFSD_V3 y
  NFSD_V3_ACL y
  NFSD_V4 y
  ${optionalString (versionAtLeast version "3.11") ''
    NFSD_V4_SECURITY_LABEL y
  ''}
  NFS_FSCACHE y
  NFS_SWAP y
  NFS_V3_ACL y
  ${optionalString (versionAtLeast version "3.11") ''
    NFS_V4_1 y  # NFSv4.1 client support
    NFS_V4_2 y
    NFS_V4_SECURITY_LABEL y
  ''}
  CIFS_XATTR y
  CIFS_POSIX y
  CIFS_FSCACHE y
  CIFS_STATS y
  CIFS_WEAK_PW_HASH y
  CIFS_UPCALL y
  CIFS_ACL y
  CIFS_DFS_UPCALL y
  ${optionalString (versionOlder version "4.13") ''
    CIFS_SMB2 y
  ''}
  ${optionalString (versionAtLeast version "3.12") ''
    CEPH_FSCACHE y
  ''}
  ${optionalString (versionAtLeast version "3.14") ''
    CEPH_FS_POSIX_ACL y
  ''}
  ${optionalString (versionAtLeast version "3.13") ''
    SQUASHFS_FILE_DIRECT y
    SQUASHFS_DECOMP_MULTI_PERCPU y
  ''}
  SQUASHFS_XATTR y
  SQUASHFS_ZLIB y
  SQUASHFS_LZO y
  SQUASHFS_XZ y
  ${optionalString (versionAtLeast version "3.19") ''
    SQUASHFS_LZ4 y
  ''}

  # Native Language Support modules, needed by some filesystems
  NLS y
  NLS_DEFAULT utf8
  NLS_UTF8 m
  NLS_CODEPAGE_437 m # VFAT default for the codepage= mount option
  NLS_ISO8859_1 m    # VFAT default for the iocharset= mount option

  # Runtime security tests
  ${optionalString (versionOlder version "4.11") ''
    DEBUG_SET_MODULE_RONX? y # Detect writes to read-only module pages
  ''}

  # Security related features.
  RANDOMIZE_BASE? y
  STRICT_DEVMEM? y # Filter access to /dev/mem
  SECURITY_SELINUX_BOOTPARAM_VALUE 0 # Disable SELinux by default
  SECURITY_YAMA? y # Prevent processes from ptracing non-children processes
  DEVKMEM n # Disable /dev/kmem
  ${optionalString (! stdenv.hostPlatform.isArm)
    (if versionOlder version "3.14" then ''
        CC_STACKPROTECTOR? y # Detect buffer overflows on the stack
      '' else ''
        CC_STACKPROTECTOR_REGULAR? y
      '')}
  ${optionalString (versionAtLeast version "3.12") ''
    USER_NS y # Support for user namespaces
  ''}

  # AppArmor support
  SECURITY_APPARMOR y
  DEFAULT_SECURITY_APPARMOR y

  # Microcode loading support
  MICROCODE y
  MICROCODE_INTEL y
  MICROCODE_AMD y
  ${optionalString (versionAtLeast version "3.11" && versionOlder version "4.4") ''
    MICROCODE_EARLY y
    MICROCODE_INTEL_EARLY y
    MICROCODE_AMD_EARLY y
  ''}

  ${optionalString (versionAtLeast version "4.10") ''
    # Write Back Throttling
    # https://lwn.net/Articles/682582/
    # https://bugzilla.kernel.org/show_bug.cgi?id=12309#c655
    BLK_WBT y
    BLK_WBT_SQ y
    BLK_WBT_MQ y
  ''}

  # Misc. options.
  8139TOO_8129 y
  8139TOO_PIO n # PIO is slower
  AIC79XX_DEBUG_ENABLE n
  AIC7XXX_DEBUG_ENABLE n
  AIC94XX_DEBUG n
  ${optionalString (versionAtLeast version "3.3" && versionOlder version "3.13") ''
    AUDIT_LOGINUID_IMMUTABLE y
  ''}
  ${optionalString (versionOlder version "4.4") ''
    B43_PCMCIA? y
  ''}
  BLK_DEV_INITRD y
  BLK_DEV_INTEGRITY y
  BSD_PROCESS_ACCT_V3 y
  BT_HCIUART_BCSP? y
  BT_HCIUART_H4? y # UART (H4) protocol support
  BT_HCIUART_LL? y
  BT_RFCOMM_TTY? y # RFCOMM TTY support
  CLEANCACHE? y
  CRASH_DUMP? n
  DVB_DYNAMIC_MINORS? y # we use udev
  EFI_STUB y # EFI bootloader in the bzImage itself
  CGROUPS y # used by systemd
  FHANDLE y # used by systemd
  SECCOMP y # used by systemd >= 231
  SECCOMP_FILTER y # ditto
  POSIX_MQUEUE y
  FRONTSWAP y
  FUSION y # Fusion MPT device support
  IDE n # deprecated IDE support
  ${optionalString (versionAtLeast version "4.3") ''
    IDLE_PAGE_TRACKING y
  ''}
  IRDA_ULTRA y # Ultra (connectionless) protocol
  JOYSTICK_IFORCE_232? y # I-Force Serial joysticks and wheels
  JOYSTICK_IFORCE_USB? y # I-Force USB joysticks and wheels
  JOYSTICK_XPAD_FF? y # X-Box gamepad rumble support
  JOYSTICK_XPAD_LEDS? y # LED Support for Xbox360 controller 'BigX' LED
  KEXEC_FILE? y
  KEXEC_JUMP? y
  LDM_PARTITION y # Windows Logical Disk Manager (Dynamic Disk) support
  LOGIRUMBLEPAD2_FF y # Logitech Rumblepad 2 force feedback
  LOGO n # not needed
  MEDIA_ATTACH y
  MEGARAID_NEWGEN y
  ${optionalString (versionAtLeast version "3.15" && versionOlder version "4.8") ''
    MLX4_EN_VXLAN y
  ''}
  ${optionalString (versionOlder version "4.9") ''
    MODVERSIONS y
  ''}
  MOUSE_PS2_ELANTECH y # Elantech PS/2 protocol extension
  MTRR_SANITIZER y
  NET_FC y # Fibre Channel driver support
  ${optionalString (versionAtLeast version "3.11") ''
    PINCTRL_BAYTRAIL y # GPIO on Intel Bay Trail, for some Chromebook internal eMMC disks
  ''}
  MMC_BLOCK_MINORS 32 # 8 is default. Modern gpt tables on eMMC may go far beyond 8.
  PPP_MULTILINK y # PPP multilink support
  PPP_FILTER y
  REGULATOR y # Voltage and Current Regulator Support
  RC_DEVICES? y # Enable IR devices
  RT2800USB_RT55XX y
  SCHED_AUTOGROUP y
  CFS_BANDWIDTH y
  SCSI_LOGGING y # SCSI logging facility
  SERIAL_8250 y # 8250/16550 and compatible serial support
  SLIP_COMPRESSED y # CSLIP compressed headers
  SLIP_SMART y
  HWMON y
  THERMAL_HWMON y # Hardware monitoring support
  ${optionalString (versionAtLeast version "3.15") ''
    UEVENT_HELPER n
  ''}
  ${optionalString (versionOlder version "3.15") ''
    USB_DEBUG? n
  ''}
  USB_EHCI_ROOT_HUB_TT y # Root Hub Transaction Translators
  USB_EHCI_TT_NEWSCHED y # Improved transaction translator scheduling
  ${optionalString (versionAtLeast version "4.3") ''
    USERFAULTFD y
  ''}
  X86_CHECK_BIOS_CORRUPTION y
  X86_MCE y

  ${optionalString (versionAtLeast version "3.12") ''
    HOTPLUG_PCI_ACPI y # PCI hotplug using ACPI
    HOTPLUG_PCI_PCIE y # PCI-Expresscard hotplug support
  ''}


  # Linux containers.
  NAMESPACES? y #  Required by 'unshare' used by 'nixos-install'
  RT_GROUP_SCHED n
  CGROUP_DEVICE? y
  MEMCG y
  MEMCG_SWAP y
  ${optionalString (versionOlder version "4.7") "DEVPTS_MULTIPLE_INSTANCES y"}
  BLK_DEV_THROTTLING y
  CFQ_GROUP_IOSCHED y
  ${optionalString (versionAtLeast version "4.3") ''
    CGROUP_PIDS y
  ''}

  # Enable staging drivers.  These are somewhat experimental, but
  # they generally don't hurt.
  STAGING y

  # PROC_EVENTS requires that the netlink connector is not built
  # as a module.  This is required by libcgroup's cgrulesengd.
  CONNECTOR y
  PROC_EVENTS y

  # Tracing.
  FTRACE y
  KPROBES y
  FUNCTION_TRACER y
  FTRACE_SYSCALLS y
  SCHED_TRACER y
  STACK_TRACER y

  ${if versionOlder version "4.11" then ''
    UPROBE_EVENT? y
  '' else ''
    UPROBE_EVENTS? y
  ''}

  ${optionalString (versionAtLeast version "4.4") ''
    BPF_SYSCALL y
    BPF_EVENTS y
  ''}
  FUNCTION_PROFILER y
  RING_BUFFER_BENCHMARK n

  # Devtmpfs support.
  DEVTMPFS y

  # Easier debugging of NFS issues.
  SUNRPC_DEBUG y

  # Virtualisation.
  PARAVIRT? y
  HYPERVISOR_GUEST y
  PARAVIRT_SPINLOCKS? y
  ${optionalString (versionOlder version "4.8") ''
    KVM_APIC_ARCHITECTURE y
  ''}
  KVM_ASYNC_PF y
  ${optionalString ((versionAtLeast version "4.0") && (versionOlder version "4.12")) ''
    KVM_COMPAT? y
  ''}
  ${optionalString (versionOlder version "4.12") ''
    KVM_DEVICE_ASSIGNMENT? y
  ''}
  ${optionalString (versionAtLeast version "4.0") ''
    KVM_GENERIC_DIRTYLOG_READ_PROTECT y
  ''}
  KVM_GUEST y
  KVM_MMIO y
  ${optionalString (versionAtLeast version "3.13") ''
    KVM_VFIO y
  ''}
  ${optionalString (stdenv.isx86_64 || stdenv.isi686) ''
    XEN? y
    XEN_DOM0? y
    ${optionalString ((versionAtLeast version "3.18") && (features.xen_dom0 or false))  ''
      PCI_XEN? y
      HVC_XEN? y
      HVC_XEN_FRONTEND? y
      XEN_SYS_HYPERVISOR? y
      SWIOTLB_XEN? y
      XEN_BACKEND? y
      XEN_BALLOON? y
      XEN_BALLOON_MEMORY_HOTPLUG? y
      XEN_EFI? y
      XEN_HAVE_PVMMU? y
      XEN_MCE_LOG? y
      XEN_PVH? y
      XEN_PVHVM? y
      XEN_SAVE_RESTORE? y
      XEN_SCRUB_PAGES? y
      XEN_SELFBALLOONING? y
      XEN_STUB? y
      XEN_TMEM? y
    ''}
  ''}
  KSM y
  ${optionalString (!stdenv.is64bit) ''
    HIGHMEM64G? y # We need 64 GB (PAE) support for Xen guest support.
  ''}
  ${optionalString (stdenv.is64bit) ''
    VFIO_PCI_VGA y
  ''}
  VIRT_DRIVERS y

  # Media support.
  MEDIA_DIGITAL_TV_SUPPORT y
  MEDIA_CAMERA_SUPPORT y
  ${optionalString (versionOlder version "4.14") ''
    MEDIA_RC_SUPPORT y
  ''}
  MEDIA_CONTROLLER y
  MEDIA_USB_SUPPORT y
  MEDIA_PCI_SUPPORT y
  MEDIA_ANALOG_TV_SUPPORT y
  VIDEO_STK1160_COMMON m
  ${optionalString (versionOlder version "4.11") ''
    VIDEO_STK1160_AC97 y
  ''}

  # Our initrd init uses shebang scripts, so can't be modular.
  BINFMT_SCRIPT y

  # For systemd-binfmt
  BINFMT_MISC? y

  # Enable the 9P cache to speed up NixOS VM tests.
  9P_FSCACHE? y
  9P_FS_POSIX_ACL? y

  # Enable transparent support for huge pages.
  TRANSPARENT_HUGEPAGE? y
  TRANSPARENT_HUGEPAGE_ALWAYS? n
  TRANSPARENT_HUGEPAGE_MADVISE? y

  # zram support (e.g for in-memory compressed swap).
  ZRAM m
  ZSWAP? y
  ZBUD? y
  ${optionalString (versionOlder version "3.18") ''
    ZSMALLOC y
  ''}
  ${optionalString (versionAtLeast version "3.18") ''
    ZSMALLOC m
  ''}

  # Enable PCIe and USB for the brcmfmac driver
  BRCMFMAC_USB? y
  BRCMFMAC_PCIE? y

  # Support x2APIC (which requires IRQ remapping).
  ${optionalString (stdenv.system == "x86_64-linux") ''
    X86_X2APIC y
    IRQ_REMAP y
  ''}

  # Disable the firmware helper fallback, udev doesn't implement it any more
  FW_LOADER_USER_HELPER_FALLBACK? n

  # Disable various self-test modules that have no use in a production system
  # This menu disables all/most of them on >= 4.16
  RUNTIME_TESTING_MENU? n
  # For older kernels, painstakingly disable each symbol.
  ARM_KPROBES_TEST? n
  ASYNC_RAID6_TEST? n
  ATOMIC64_SELFTEST? n
  BACKTRACE_SELF_TEST? n
  CRC32_SELFTEST? n
  CRYPTO_TEST? n
  DRM_DEBUG_MM_SELFTEST? n
  EFI_TEST? n
  GLOB_SELFTEST? n
  INTERVAL_TREE_TEST? n
  LNET_SELFTEST? n
  LOCK_TORTURE_TEST? n
  MTD_TESTS? n
  NOTIFIER_ERROR_INJECTION? n
  PERCPU_TEST? n
  RBTREE_TEST? n
  RCU_PERF_TEST? n
  RCU_TORTURE_TEST? n
  TEST_ASYNC_DRIVER_PROBE? n
  TEST_BITMAP? n
  TEST_BPF? n
  TEST_FIRMWARE? n
  TEST_HASH? n
  TEST_HEXDUMP? n
  TEST_KMOD? n
  TEST_KSTRTOX? n
  TEST_LIST_SORT? n
  TEST_LKM? n
  TEST_PARMAN? n
  TEST_PRINTF? n
  TEST_RHASHTABLE? n
  TEST_SORT? n
  TEST_STATIC_KEYS? n
  TEST_STRING_HELPERS? n
  TEST_UDELAY? n
  TEST_USER_COPY? n
  TEST_UUID? n
  WW_MUTEX_SELFTEST? n
  XZ_DEC_TEST? n

  ${optionalString (features.criu or false)  ''
    EXPERT y
    CHECKPOINT_RESTORE y
  ''}

  ${optionalString ((features.criu or false) && (features.criu_revert_expert or true))
    # Revert some changes, introduced by EXPERT, when necessary for criu
  ''
    RFKILL_INPUT? y
    HID_PICOLCD_FB? y
    HID_PICOLCD_BACKLIGHT? y
    HID_PICOLCD_LCD? y
    HID_PICOLCD_LEDS? y
    HID_PICOLCD_CIR? y
    DEBUG_MEMORY_INIT? y
  ''}

  ${optionalString (features.debug or false)  ''
    DEBUG_INFO y
  ''}

  ${extraConfig}
''
