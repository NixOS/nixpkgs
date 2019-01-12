# WARNING/NOTE: whenever you want to add an option here you need to either
# * mark it as an optional one with `option`,
# * or make sure it works for all the versions in nixpkgs,
# * or check for which kernel versions it will work (using kernel
#   changelog, google or whatever) and mark it with `whenOlder` or
#   `whenAtLeast`.
# Then do test your change by building all the kernels (or at least
# their configs) in Nixpkgs or else you will guarantee lots and lots
# of pain to users trying to switch to an older kernel because of some
# hardware problems with a new one.

# Configuration
{ stdenv, version

# to let user override values, aka converting modules to included and vice-versa
, mkValueOverride ? null

# new extraConfig as a flattened set
, structuredExtraConfig ? {}

# legacy extraConfig as string
, extraConfig ? ""

, features ? { grsecurity = false; xen_dom0 = false; }
}:

assert (mkValueOverride == null) || (builtins.isFunction mkValueOverride);

with stdenv.lib;

with import ../../../../lib/kernel.nix { inherit (stdenv) lib; inherit version; };

let

  # configuration items have to be part of a subattrs
  flattenKConf =  nested: mapAttrs (_: head) (zipAttrs (attrValues nested));

  options = {

    debug = {
      DEBUG_INFO                = if (features.debug or false) then yes else no;
      DEBUG_KERNEL              = yes;
      DEBUG_DEVRES              = no;
      DYNAMIC_DEBUG             = yes;
      TIMER_STATS               = whenOlder "4.11" yes;
      DEBUG_NX_TEST             = whenOlder "4.11" no;
      CPU_NOTIFIER_ERROR_INJECT = whenOlder "4.4" (option no);
      DEBUG_STACK_USAGE         = no;
      DEBUG_STACKOVERFLOW       = when (!features.grsecurity) no;
      RCU_TORTURE_TEST          = no;
      SCHEDSTATS                = no;
      DETECT_HUNG_TASK          = yes;
      CRASH_DUMP                = option no;
      # Easier debugging of NFS issues.
      SUNRPC_DEBUG              = yes;
    };

    power-management = {
      PM_ADVANCED_DEBUG                = yes;
      X86_INTEL_LPSS                   = yes;
      X86_INTEL_PSTATE                 = yes;
      INTEL_IDLE                       = yes;
      CPU_FREQ_DEFAULT_GOV_PERFORMANCE = yes;
      CPU_FREQ_GOV_SCHEDUTIL           = whenAtLeast "4.9" yes;
      PM_WAKELOCKS                     = yes;
    };

    external-firmware = {
      # Support drivers that need external firmware.
      STANDALONE = no;
    };

    proc-config-gz = {
      # Make /proc/config.gz available
      IKCONFIG      = yes;
      IKCONFIG_PROC = yes;
    };

    optimization = {
      # Optimize with -O2, not -Os
      CC_OPTIMIZE_FOR_SIZE = no;
    };

    memtest = {
      MEMTEST = yes;
    };

    # Include the CFQ I/O scheduler in the kernel, rather than as a
    # module, so that the initrd gets a good I/O scheduler.
    scheduler = {
      IOSCHED_CFQ = yes;
      BLK_CGROUP  = yes; # required by CFQ"
      IOSCHED_DEADLINE = yes;
      MQ_IOSCHED_DEADLINE = whenAtLeast "4.11" yes;
      BFQ_GROUP_IOSCHED = whenAtLeast "4.12" yes;
      MQ_IOSCHED_KYBER = whenAtLeast "4.12" yes;
      IOSCHED_BFQ = whenAtLeast "4.12" module;
    };

    # Enable NUMA.
    numa = {
      NUMA  = option yes;
    };

    networking = {
      NET                = yes;
      IP_PNP             = no;
      NETFILTER          = yes;
      NETFILTER_ADVANCED = yes;
      IP_VS_PROTO_TCP    = yes;
      IP_VS_PROTO_UDP    = yes;
      IP_VS_PROTO_ESP    = yes;
      IP_VS_PROTO_AH     = yes;
      IP_DCCP_CCID3      = no; # experimental
      CLS_U32_PERF       = yes;
      CLS_U32_MARK       = yes;
      BPF_JIT            = when (stdenv.hostPlatform.system == "x86_64-linux") yes;
      WAN                = yes;
      # Required by systemd per-cgroup firewalling
      CGROUP_BPF                  = option yes;
      CGROUP_NET_PRIO             = yes; # Required by systemd
      IP_ROUTE_VERBOSE            = yes;
      IP_MROUTE_MULTIPLE_TABLES   = yes;
      IP_MULTICAST                = yes;
      IPV6_ROUTER_PREF            = yes;
      IPV6_ROUTE_INFO             = yes;
      IPV6_OPTIMISTIC_DAD         = yes;
      IPV6_MULTIPLE_TABLES        = yes;
      IPV6_SUBTREES               = yes;
      IPV6_MROUTE                 = yes;
      IPV6_MROUTE_MULTIPLE_TABLES = yes;
      IPV6_PIMSM_V2               = yes;
      IPV6_FOU_TUNNEL             = whenAtLeast "4.7" module;
      NET_CLS_BPF                 = whenAtLeast "4.4" module;
      NET_ACT_BPF                 = whenAtLeast "4.4" module;
      L2TP_V3                     = yes;
      L2TP_IP                     = module;
      L2TP_ETH                    = module;
      BRIDGE_VLAN_FILTERING       = yes;
      BONDING                     = module;
      NET_L3_MASTER_DEV           = option yes;
      NET_FOU_IP_TUNNELS          = option yes;
      IP_NF_TARGET_REDIRECT       = module;

      PPP_MULTILINK = yes; # PPP multilink support
      PPP_FILTER    = yes;

      # needed for iwd WPS support (wpa_supplicant replacement)
      KEY_DH_OPERATIONS = whenAtLeast "4.7" yes;

      # needed for nftables
      NF_TABLES_INET              = whenAtLeast "4.17" yes;
      NF_TABLES_NETDEV            = whenAtLeast "4.17" yes;
      NF_TABLES_IPV4              = whenAtLeast "4.17" yes;
      NF_TABLES_ARP               = whenAtLeast "4.17" yes;
      NF_TABLES_IPV6              = whenAtLeast "4.17" yes;
      NF_TABLES_BRIDGE            = whenAtLeast "4.17" yes;
    };

    wireless = {
      CFG80211_WEXT         = option yes; # Without it, ipw2200 drivers don't build
      IPW2100_MONITOR       = option yes; # support promiscuous mode
      IPW2200_MONITOR       = option yes; # support promiscuous mode
      HOSTAP_FIRMWARE       = option yes; # Support downloading firmware images with Host AP driver
      HOSTAP_FIRMWARE_NVRAM = option yes;
      ATH9K_PCI             = option yes; # Detect Atheros AR9xxx cards on PCI(e) bus
      ATH9K_AHB             = option yes; # Ditto, AHB bus
      B43_PHY_HT            = option yes;
      BCMA_HOST_PCI         = option yes;
    };

    fb = {
      FB                  = yes;
      FB_EFI              = yes;
      FB_NVIDIA_I2C       = yes; # Enable DDC Support
      FB_RIVA_I2C         = yes;
      FB_ATY_CT           = yes; # Mach64 CT/VT/GT/LT (incl. 3D RAGE) support
      FB_ATY_GX           = yes; # Mach64 GX support
      FB_SAVAGE_I2C       = yes;
      FB_SAVAGE_ACCEL     = yes;
      FB_SIS_300          = yes;
      FB_SIS_315          = yes;
      FB_3DFX_ACCEL       = yes;
      FB_VESA             = yes;
      FRAMEBUFFER_CONSOLE = yes;
      FRAMEBUFFER_CONSOLE_ROTATION = yes;
      FB_GEODE            = when (stdenv.hostPlatform.system == "i686-linux") yes;
    };

    video = {
      # Enable KMS for devices whose X.org driver supports it
      DRM_I915_KMS           = whenOlder "4.3" yes;
      # Allow specifying custom EDID on the kernel command line
      DRM_LOAD_EDID_FIRMWARE = yes;
      VGA_SWITCHEROO         = yes; # Hybrid graphics support
      DRM_GMA600             = yes;
      DRM_GMA3600            = yes;
      # necessary for amdgpu polaris support
      DRM_AMD_POWERPLAY = whenBetween "4.5" "4.9" yes;
      # (experimental) amdgpu support for verde and newer chipsets
      DRM_AMDGPU_SI = whenAtLeast "4.9" yes;
      # (stable) amdgpu support for bonaire and newer chipsets
      DRM_AMDGPU_CIK = whenAtLeast "4.9" yes;
    } // optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux") {
      # Intel GVT-g graphics virtualization supports 64-bit only
      DRM_I915_GVT = whenAtLeast "4.16" yes;
      DRM_I915_GVT_KVMGT = whenAtLeast "4.16" module;
    };

    sound = {
      SND_DYNAMIC_MINORS  = yes;
      SND_AC97_POWER_SAVE = yes; # AC97 Power-Saving Mode
      SND_HDA_INPUT_BEEP  = yes; # Support digital beep via input layer
      SND_HDA_RECONFIG    = yes; # Support reconfiguration of jack functions
      # Support configuring jack functions via fw mechanism at boot
      SND_HDA_PATCH_LOADER = yes;
      SND_USB_CAIAQ_INPUT = yes;
      # Enable PSS mixer (Beethoven ADSP-16 and other compatible)
      PSS_MIXER           = whenOlder "4.12" yes;
    };

    usb-serial = {
      USB_SERIAL_GENERIC          = yes; # USB Generic Serial Driver
    } // optionalAttrs (versionOlder version "4.16") {
      # Include firmware for various USB serial devices.
      # Only applicable for kernels below 4.16, after that no firmware is shipped in the kernel tree.
      USB_SERIAL_KEYSPAN_MPR      = yes;
      USB_SERIAL_KEYSPAN_USA28    = yes;
      USB_SERIAL_KEYSPAN_USA28X   = yes;
      USB_SERIAL_KEYSPAN_USA28XA  = yes;
      USB_SERIAL_KEYSPAN_USA28XB  = yes;
      USB_SERIAL_KEYSPAN_USA19    = yes;
      USB_SERIAL_KEYSPAN_USA18X   = yes;
      USB_SERIAL_KEYSPAN_USA19W   = yes;
      USB_SERIAL_KEYSPAN_USA19QW  = yes;
      USB_SERIAL_KEYSPAN_USA19QI  = yes;
      USB_SERIAL_KEYSPAN_USA49W   = yes;
      USB_SERIAL_KEYSPAN_USA49WLC = yes;
    };

    usb = {
      USB_DEBUG            = option (whenOlder "4.18" no);
      USB_EHCI_ROOT_HUB_TT = yes; # Root Hub Transaction Translators
      USB_EHCI_TT_NEWSCHED = yes; # Improved transaction translator scheduling
    };

    # Filesystem options - in particular, enable extended attributes and
    # ACLs for all filesystems that support them.
    filesystem = {
      FANOTIFY        = yes;
      TMPFS           = yes;
      TMPFS_POSIX_ACL = yes;
      FS_ENCRYPTION   = option (whenAtLeast "4.9" module);

      EXT2_FS_XATTR     = yes;
      EXT2_FS_POSIX_ACL = yes;
      EXT2_FS_SECURITY  = yes;
      EXT2_FS_XIP       = whenOlder "4.0" yes; # Ext2 execute in place support

      EXT3_FS_POSIX_ACL = yes;
      EXT3_FS_SECURITY  = yes;

      EXT4_FS_POSIX_ACL = yes;
      EXT4_FS_SECURITY  = yes;
      EXT4_ENCRYPTION   = option ((if (versionOlder version "4.8") then module else yes));

      REISERFS_FS_XATTR     = option yes;
      REISERFS_FS_POSIX_ACL = option yes;
      REISERFS_FS_SECURITY  = option yes;

      JFS_POSIX_ACL = option yes;
      JFS_SECURITY  = option yes;

      XFS_QUOTA     = option yes;
      XFS_POSIX_ACL = option yes;
      XFS_RT        = option yes; # XFS Realtime subvolume support

      OCFS2_DEBUG_MASKLOG = option no;

      BTRFS_FS_POSIX_ACL = yes;

      UBIFS_FS_ADVANCED_COMPR = option yes;

      F2FS_FS             = module;
      F2FS_FS_SECURITY    = option yes;
      F2FS_FS_ENCRYPTION  = option yes;
      UDF_FS              = module;

      NFSD_PNFS              = whenBetween "4.0" "4.6" yes;
      NFSD_V2_ACL            = yes;
      NFSD_V3                = yes;
      NFSD_V3_ACL            = yes;
      NFSD_V4                = yes;
      NFSD_V4_SECURITY_LABEL = yes;

      NFS_FSCACHE           = yes;
      NFS_SWAP              = yes;
      NFS_V3_ACL            = yes;
      NFS_V4_1              = yes;  # NFSv4.1 client support
      NFS_V4_2              = yes;
      NFS_V4_SECURITY_LABEL = yes;

      CIFS_XATTR        = yes;
      CIFS_POSIX        = option yes;
      CIFS_FSCACHE      = yes;
      CIFS_STATS        = whenOlder "4.19" yes;
      CIFS_WEAK_PW_HASH = yes;
      CIFS_UPCALL       = yes;
      CIFS_ACL          = yes;
      CIFS_DFS_UPCALL   = yes;
      CIFS_SMB2         = whenOlder "4.13" yes;

      CEPH_FSCACHE      = yes;
      CEPH_FS_POSIX_ACL = yes;

      SQUASHFS_FILE_DIRECT         = yes;
      SQUASHFS_DECOMP_MULTI_PERCPU = yes;
      SQUASHFS_XATTR               = yes;
      SQUASHFS_ZLIB                = yes;
      SQUASHFS_LZO                 = yes;
      SQUASHFS_XZ                  = yes;
      SQUASHFS_LZ4                 = yes;

      # Native Language Support modules, needed by some filesystems
      NLS              = yes;
      NLS_DEFAULT      = "utf8";
      NLS_UTF8         = module;
      NLS_CODEPAGE_437 = module; # VFAT default for the codepage= mount option
      NLS_ISO8859_1    = module; # VFAT default for the iocharset= mount option

      DEVTMPFS = yes;
    };

    security = {
      # Detect writes to read-only module pages
      DEBUG_SET_MODULE_RONX            = option (whenOlder "4.11" yes);
      RANDOMIZE_BASE                   = option yes;
      STRICT_DEVMEM                    = option yes; # Filter access to /dev/mem
      SECURITY_SELINUX_BOOTPARAM_VALUE = "0"; # Disable SELinux by default
      # Prevent processes from ptracing non-children processes
      SECURITY_YAMA                    = option yes;
      DEVKMEM                          = when (!features.grsecurity) no; # Disable /dev/kmem

      USER_NS                          = yes; # Support for user namespaces

      SECURITY_APPARMOR                = yes;
      DEFAULT_SECURITY_APPARMOR        = yes;

    } // optionalAttrs (!stdenv.hostPlatform.isAarch32) {

      # Detect buffer overflows on the stack
      CC_STACKPROTECTOR_REGULAR = option (whenOlder "4.18" yes);
    };

    microcode = {
      MICROCODE       = yes;
      MICROCODE_INTEL = yes;
      MICROCODE_AMD   = yes;

      MICROCODE_EARLY       = whenOlder "4.4" yes;
      MICROCODE_INTEL_EARLY = whenOlder "4.4" yes;
      MICROCODE_AMD_EARLY   = whenOlder "4.4" yes;
    } // optionalAttrs (versionAtLeast version "4.10") {
      # Write Back Throttling
      # https://lwn.net/Articles/682582/
      # https://bugzilla.kernel.org/show_bug.cgi?id=12309#c655
      BLK_WBT    = yes;
      BLK_WBT_SQ = yes;
      BLK_WBT_MQ = yes;
    };

    container = {
      NAMESPACES     = option yes; #  Required by 'unshare' used by 'nixos-install'
      RT_GROUP_SCHED = no;
      CGROUP_DEVICE  = option yes;

      MEMCG                    = yes;
      MEMCG_SWAP               = yes;

      DEVPTS_MULTIPLE_INSTANCES = whenOlder "4.7" yes;
      BLK_DEV_THROTTLING        = yes;
      CFQ_GROUP_IOSCHED         = yes;
      CGROUP_PIDS               = whenAtLeast "4.3" yes;
    };

    staging = {
      # Enable staging drivers.  These are somewhat experimental, but
      # they generally don't hurt.
      STAGING = yes;
    };

    proc-events = {
      # PROC_EVENTS requires that the netlink connector is not built
      # as a module.  This is required by libcgroup's cgrulesengd.
      CONNECTOR   = yes;
      PROC_EVENTS = yes;
    };

    tracing = {
      FTRACE                = yes;
      KPROBES               = yes;
      FUNCTION_TRACER       = yes;
      FTRACE_SYSCALLS       = yes;
      SCHED_TRACER          = yes;
      STACK_TRACER          = yes;
      UPROBE_EVENT          = option (whenOlder "4.11" yes);
      UPROBE_EVENTS         = option (whenAtLeast "4.11" yes);
      BPF_SYSCALL           = whenAtLeast "4.4" yes;
      BPF_EVENTS            = whenAtLeast "4.4" yes;
      FUNCTION_PROFILER     = yes;
      RING_BUFFER_BENCHMARK = no;
    };

    virtualisation = {
      PARAVIRT = option yes;

      HYPERVISOR_GUEST = when (!features.grsecurity) yes;
      PARAVIRT_SPINLOCKS  = option yes;

      KVM_APIC_ARCHITECTURE             = whenOlder "4.8" yes;
      KVM_ASYNC_PF                      = yes;
      KVM_COMPAT                        = option (whenBetween "4.0" "4.12"  yes);
      KVM_DEVICE_ASSIGNMENT             = option (whenBetween "3.10" "4.12" yes);
      KVM_GENERIC_DIRTYLOG_READ_PROTECT = whenAtLeast "4.0"  yes;
      KVM_GUEST                         = when (!features.grsecurity) yes;
      KVM_MMIO                          = yes;
      KVM_VFIO                          = yes;
      KSM = yes;
      VIRT_DRIVERS = yes;
      # We nneed 64 GB (PAE) support for Xen guest support
      HIGHMEM64G = option (when (!stdenv.is64bit) yes);

      VFIO_PCI_VGA = when stdenv.is64bit yes;

    } // optionalAttrs (stdenv.isx86_64 || stdenv.isi686) ({
      XEN = option yes;

      # XXX: why isn't this in the xen-dom0 conditional section below?
      XEN_DOM0 = option yes;

    } // optionalAttrs features.xen_dom0 {
      PCI_XEN                     = option yes;
      HVC_XEN                     = option yes;
      HVC_XEN_FRONTEND            = option yes;
      XEN_SYS_HYPERVISOR          = option yes;
      SWIOTLB_XEN                 = option yes;
      XEN_BACKEND                 = option yes;
      XEN_BALLOON                 = option yes;
      XEN_BALLOON_MEMORY_HOTPLUG  = option yes;
      XEN_EFI                     = option yes;
      XEN_HAVE_PVMMU              = option yes;
      XEN_MCE_LOG                 = option yes;
      XEN_PVH                     = option yes;
      XEN_PVHVM                   = option yes;
      XEN_SAVE_RESTORE            = option yes;
      XEN_SCRUB_PAGES             = option yes;
      XEN_SELFBALLOONING          = option yes;
      XEN_STUB                    = option yes;
      XEN_TMEM                    = option yes;
    });

    media = {
      MEDIA_DIGITAL_TV_SUPPORT = yes;
      MEDIA_CAMERA_SUPPORT     = yes;
      MEDIA_RC_SUPPORT         = whenOlder "4.14" yes;
			MEDIA_CONTROLLER         = yes;
      MEDIA_PCI_SUPPORT        = yes;
      MEDIA_USB_SUPPORT        = yes;
      MEDIA_ANALOG_TV_SUPPORT  = yes;
      VIDEO_STK1160_COMMON     = module;
      VIDEO_STK1160_AC97       = whenOlder "4.11" yes;
    };

    "9p" = {
      # Enable the 9P cache to speed up NixOS VM tests.
      "9P_FSCACHE"      = option yes;
      "9P_FS_POSIX_ACL" = option yes;
    };

    huge-page = {
      TRANSPARENT_HUGEPAGE         = option yes;
      TRANSPARENT_HUGEPAGE_ALWAYS  = option no;
      TRANSPARENT_HUGEPAGE_MADVISE = option yes;
    };

    zram = {
      ZRAM     = module;
      ZSWAP    = option yes;
      ZBUD     = option yes;
      ZSMALLOC = module;
    };

    brcmfmac = {
      # Enable PCIe and USB for the brcmfmac driver
      BRCMFMAC_USB  = option yes;
      BRCMFMAC_PCIE = option yes;
    };

    # Support x2APIC (which requires IRQ remapping)
    x2apic = optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux") {
      X86_X2APIC = yes;
      IRQ_REMAP  = yes;
    };

    # Disable various self-test modules that have no use in a production system
    tests = {
      # This menu disables all/most of them on >= 4.16
      RUNTIME_TESTING_MENU = option no;
    } // optionalAttrs (versionOlder version "4.16") {
      # For older kernels, painstakingly disable each symbol.
      ARM_KPROBES_TEST    = option no;
      ASYNC_RAID6_TEST    = option no;
      ATOMIC64_SELFTEST   = option no;
      BACKTRACE_SELF_TEST = option no;
      INTERVAL_TREE_TEST  = option no;
      PERCPU_TEST         = option no;
      RBTREE_TEST         = option no;
      TEST_BITMAP         = option no;
      TEST_BPF            = option no;
      TEST_FIRMWARE       = option no;
      TEST_HASH           = option no;
      TEST_HEXDUMP        = option no;
      TEST_KMOD           = option no;
      TEST_KSTRTOX        = option no;
      TEST_LIST_SORT      = option no;
      TEST_LKM            = option no;
      TEST_PARMAN         = option no;
      TEST_PRINTF         = option no;
      TEST_RHASHTABLE     = option no;
      TEST_SORT           = option no;
      TEST_STATIC_KEYS    = option no;
      TEST_STRING_HELPERS = option no;
      TEST_UDELAY         = option no;
      TEST_USER_COPY      = option no;
      TEST_UUID           = option no;
    } // {
      CRC32_SELFTEST           = option no;
      CRYPTO_TEST              = option no;
      EFI_TEST                 = option no;
      GLOB_SELFTEST            = option no;
      DRM_DEBUG_MM_SELFTEST    = option (whenOlder "4.18" no);
      LNET_SELFTEST            = option (whenOlder "4.18" no);
      LOCK_TORTURE_TEST        = option no;
      MTD_TESTS                = option no;
      NOTIFIER_ERROR_INJECTION = option no;
      RCU_PERF_TEST            = option no;
      RCU_TORTURE_TEST         = option no;
      TEST_ASYNC_DRIVER_PROBE  = option no;
      WW_MUTEX_SELFTEST        = option no;
      XZ_DEC_TEST              = option no;
    } // optionalAttrs (features.criu or false) ({
      EXPERT              = yes;
      CHECKPOINT_RESTORE  = yes;
    } // optionalAttrs (features.criu_revert_expert or true) {
      RFKILL_INPUT          = option yes;
      HID_PICOLCD_FB        = option yes;
      HID_PICOLCD_BACKLIGHT = option yes;
      HID_PICOLCD_LCD       = option yes;
      HID_PICOLCD_LEDS      = option yes;
      HID_PICOLCD_CIR       = option yes;
      DEBUG_MEMORY_INIT     = option yes;
    });

    misc = {
      MODULE_COMPRESS    = yes;
      MODULE_COMPRESS_XZ = yes;
      KERNEL_XZ          = yes;

      UNIX               = yes;  # Unix domain sockets.

      MD                 = yes;     # Device mapper (RAID, LVM, etc.)

      # Enable initrd support.
      BLK_DEV_RAM       = yes;
      BLK_DEV_INITRD    = yes;

      PM_TRACE_RTC         = no; # Disable some expensive (?) features.
      ACCESSIBILITY        = yes; # Accessibility support
      AUXDISPLAY           = yes; # Auxiliary Display support
      DONGLE               = whenOlder "4.17" yes; # Serial dongle support
      HIPPI                = yes;
      MTD_COMPLEX_MAPPINGS = yes; # needed for many devices

      SCSI_LOWLEVEL        = yes; # enable lots of SCSI devices
      SCSI_LOWLEVEL_PCMCIA = yes;
      SCSI_SAS_ATA         = yes; # added to enable detection of hard drive

      SPI        = yes; # needed for many devices
      SPI_MASTER = yes;

      "8139TOO_8129" = yes;
      "8139TOO_PIO"  = no; # PIO is slower

      AIC79XX_DEBUG_ENABLE = no;
      AIC7XXX_DEBUG_ENABLE = no;
      AIC94XX_DEBUG = no;
      B43_PCMCIA = option (whenOlder "4.4" yes);

      BLK_DEV_INTEGRITY       = yes;

      BSD_PROCESS_ACCT_V3 = yes;

      BT_HCIUART_BCSP = option yes;
      BT_HCIUART_H4   = option yes; # UART (H4) protocol support
      BT_HCIUART_LL   = option yes;
      BT_RFCOMM_TTY   = option yes; # RFCOMM TTY support

      CLEANCACHE = option yes;
      CRASH_DUMP = option no;

      DVB_DYNAMIC_MINORS = option yes; # we use udev

      EFI_STUB            = yes; # EFI bootloader in the bzImage itself
      CGROUPS             = yes; # used by systemd
      FHANDLE             = yes; # used by systemd
      SECCOMP             = yes; # used by systemd >= 231
      SECCOMP_FILTER      = yes; # ditto
      POSIX_MQUEUE        = yes;
      FRONTSWAP           = yes;
      FUSION              = yes; # Fusion MPT device support
      IDE                 = no; # deprecated IDE support
      IDLE_PAGE_TRACKING  = yes;
      IRDA_ULTRA          = whenOlder "4.17" yes; # Ultra (connectionless) protocol

      JOYSTICK_IFORCE_232 = option yes; # I-Force Serial joysticks and wheels
      JOYSTICK_IFORCE_USB = option yes; # I-Force USB joysticks and wheels
      JOYSTICK_XPAD_FF    = option yes; # X-Box gamepad rumble support
      JOYSTICK_XPAD_LEDS  = option yes; # LED Support for Xbox360 controller 'BigX' LED

      KEXEC_FILE      = option yes;
      KEXEC_JUMP      = option yes;

      # Windows Logical Disk Manager (Dynamic Disk) support
      LDM_PARTITION         = yes;
      LOGIRUMBLEPAD2_FF     = yes; # Logitech Rumblepad 2 force feedback
      LOGO                  = no; # not needed
      MEDIA_ATTACH          = yes;
      MEGARAID_NEWGEN       = yes;

      MLX4_EN_VXLAN = whenOlder "4.8" yes;
      MLX5_CORE_EN       = option yes;

      MODVERSIONS        = whenOlder "4.9" yes;
      MOUSE_PS2_ELANTECH = yes; # Elantech PS/2 protocol extension
      MTRR_SANITIZER     = yes;
      NET_FC             = yes; # Fibre Channel driver support
      # GPIO on Intel Bay Trail, for some Chromebook internal eMMC disks
      PINCTRL_BAYTRAIL   = yes;
      # 8 is default. Modern gpt tables on eMMC may go far beyond 8.
      MMC_BLOCK_MINORS   = "32";

      REGULATOR  = yes; # Voltage and Current Regulator Support
      RC_DEVICES = option yes; # Enable IR devices

      RT2800USB_RT53XX = yes;
      RT2800USB_RT55XX = yes;

      SCHED_AUTOGROUP  = yes;
      CFS_BANDWIDTH    = yes;

      SCSI_LOGGING = yes; # SCSI logging facility
      SERIAL_8250  = yes; # 8250/16550 and compatible serial support

      SLIP_COMPRESSED = yes; # CSLIP compressed headers
      SLIP_SMART      = yes;

      HWMON         = yes;
      THERMAL_HWMON = yes; # Hardware monitoring support
      UEVENT_HELPER = no;

      USERFAULTFD   = yes;
      X86_CHECK_BIOS_CORRUPTION = yes;
      X86_MCE                   = yes;

      # Our initrd init uses shebang scripts, so can't be modular.
      BINFMT_SCRIPT = yes;
      # For systemd-binfmt
      BINFMT_MISC   = option yes;

      # Disable the firmware helper fallback, udev doesn't implement it any more
      FW_LOADER_USER_HELPER_FALLBACK = option no;

      HOTPLUG_PCI_ACPI = yes; # PCI hotplug using ACPI
      HOTPLUG_PCI_PCIE = yes; # PCI-Expresscard hotplug support

    } // optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "aarch64-linux") {
      # Bump the maximum number of CPUs to support systems like EC2 x1.*
      # instances and Xeon Phi.
      NR_CPUS = "384";
    };
  };
in (generateNixKConf ((flattenKConf options) // structuredExtraConfig) mkValueOverride) + extraConfig
