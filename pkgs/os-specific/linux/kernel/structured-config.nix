# Configuration
{ lib, version, system, is64bit }:

# Optional features
{ grsecurity ? false, xen_dom0 ? false }:

with lib; let 
  # Borrowed from aszlig here: https://github.com/openlab-aux/vuizvui/blob/master/modules/user/aszlig/system/kernel.nix#L8-L18
  generateKConf = exprs: let
    isNumber = c: elem c ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"];
    mkValue = val:
      if val == "" then "\"\""
      else if val == yes || val == module || val == no then val
      else if all isNumber (stringToCharacters val) then val
      else if substring 0 2 val == "0x" then val
      else "\"${val}\"";
    mkConfigLine = key: val:
      if val == null
        then ""
        else if hasPrefix "?" val
          then "${key}?=${mkValue (removePrefix "?" val)}\n"
          else "${key}=${mkValue val}\n";
    mkConf = cfg: concatStrings (mapAttrsToList mkConfigLine cfg);
  in mkConf exprs;

  flattenKConf = nested: mapAttrs (_: head) (zipAttrs (attrValues nested));

  # Common patterns
  when        = cond: opt: if cond then opt else null;
  whenAtLeast = ver: when (versionAtLeast version ver);
  whenOlder   = ver: when (versionOlder version ver);
  whenBetween = verLow: verHigh: when (versionAtLeast version verLow && versionOlder version verHigh);

  # Keeping these around in case we decide to change this horrible implementation :)
  option = x: if x == null then null else "?${x}";
  yes    = "y";
  no     = "n";
  module = "m";

  options = {
    debug = {
      DEBUG_KERNEL              = yes;
      TIMER_STATS               = yes;
      BACKTRACE_SELF_TEST       = no;
      CPU_NOTIFIER_ERROR_INJECT = option no;
      DEBUG_DEVRES              = no;
      DEBUG_NX_TEST             = no;
      DEBUG_STACK_USAGE         = no;
      DEBUG_STACKOVERFLOW       = when (!grsecurity) no;
      RCU_TORTURE_TEST          = no;
      SCHEDSTATS                = no;
      DETECT_HUNG_TASK          = yes;
      CRASH_DUMP                = option no;
      SUNRPC_DEBUG              = whenAtLeast "3.4" yes;
    };

    power-management = {
      PM_RUNTIME                       = whenOlder "3.19" yes;
      PM_ADVANCED_DEBUG                = yes;
      X86_INTEL_LPSS                   = whenAtLeast "3.11" yes;
      X86_INTEL_PSTATE                 = whenAtLeast "3.10" yes;
      INTEL_IDLE                       = yes;
      CPU_FREQ_DEFAULT_GOV_PERFORMANCE = yes;
      USB_SUSPEND                      = whenOlder "3.10" yes;
    };

    external-firmware = {
      STANDALONE = no;
    };

    proc-config-gz = {
      IKCONFIG      = yes;
      IKCONFIG_PROC = yes;
    };

    optimization = {
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
    };

    # Enable NUMA.
    numa = {
      NUMA  = option yes;
    };

    networking = {
      IP_PNP             = no;
      IPV6_PRIVACY       = whenOlder "3.13" yes;
      NETFILTER_ADVANCED = yes;
      IP_VS_PROTO_TCP    = yes;
      IP_VS_PROTO_UDP    = yes;
      IP_VS_PROTO_ESP    = yes;
      IP_VS_PROTO_AH     = yes;
      IP_DCCP_CCID3      = no; # experimental
      CLS_U32_PERF       = yes;
      CLS_U32_MARK       = yes;    
      BPF_JIT            = yes;
      WAN                = yes;
    };

    wireless = {
      CFG80211_WEXT         = option yes; # Without it, ipw2200 drivers don't build
      IPW2100_MONITOR       = option yes; # support promiscuous mode
      IPW2200_MONITOR       = option yes; # support promiscuous mode
      HOSTAP_FIRMWARE       = option yes; # Support downloading firmware images with Host AP driver
      HOSTAP_FIRMWARE_NVRAM = option yes;
      ATH9K_PCI             = option yes; # Detect Atheros AR9xxx cards on PCI(e) bus
      ATH9K_AHB             = option yes; # Ditto, AHB bus
      B43_PHY_HT            = option (whenAtLeast "3.2" yes);
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
      FB_GEODE            = when (versionOlder version "3.9" || system == "i686-linux") yes;
    };

    video = {
      DRM_I915_KMS           = whenOlder "4.3" yes; # Enable KMS for devices whose X.org driver supports it.
      DRM_LOAD_EDID_FIRMWARE = yes; # Allow specifying custom EDID on the kernel command line
      DRM_RADEON_KMS         = option (whenOlder "3.9" yes);
      VGA_SWITCHEROO         = yes; # Hybrid graphics support
    };

    sound = {
      SND_DYNAMIC_MINORS  = yes;
      SND_AC97_POWER_SAVE = yes; # AC97 Power-Saving Mode
      SND_HDA_INPUT_BEEP  = yes; # Support digital beep via input layer
      SND_USB_CAIAQ_INPUT = yes;
      PSS_MIXER           = yes; # Enable PSS mixer (Beethoven ADSP-16 and other compatible)
    };

    usb-serial = {
      USB_SERIAL_GENERIC          = yes; # USB Generic Serial Driver
      USB_SERIAL_KEYSPAN_MPR      = yes; # include firmware for various USB serial devices
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
      USB_DEBUG            = option (whenOlder "3.15" no);
      USB_EHCI_ROOT_HUB_TT = yes; # Root Hub Transaction Translators
      USB_EHCI_TT_NEWSCHED = yes; # Improved transaction translator scheduling
    };

    filesystem = {
      FANOTIFY = yes;

      EXT2_FS_XATTR     = yes;
      EXT2_FS_POSIX_ACL = yes;
      EXT2_FS_SECURITY  = yes;
      EXT2_FS_XIP       = whenOlder "4.0" yes; # Ext2 execute in place support
      
      EXT3_FS_POSIX_ACL = yes;
      EXT3_FS_SECURITY  = yes;
      
      EXT4_FS_POSIX_ACL = yes;
      EXT4_FS_SECURITY  = yes;
      
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

      NFSD_PNFS              = whenAtLeast "4.0" yes;
      NFSD_V2_ACL            = yes;
      NFSD_V3                = yes;
      NFSD_V3_ACL            = yes;
      NFSD_V4                = yes;
      NFSD_V4_SECURITY_LABEL = whenAtLeast "3.11" yes;

      NFS_FSCACHE           = yes;
      NFS_SWAP              = whenAtLeast "3.6" yes;
      NFS_V3_ACL            = yes;
      NFS_V4_1              = whenAtLeast "3.11" yes;  # NFSv4.1 client support
      NFS_V4_2              = whenAtLeast "3.11" yes;
      NFS_V4_SECURITY_LABEL = whenAtLeast "3.11" yes;

      CIFS_XATTR   = yes;
      CIFS_POSIX   = yes;
      CIFS_FSCACHE = yes;

      CEPH_FSCACHE      = whenAtLeast "3.12" yes;
      CEPH_FS_POSIX_ACL = whenAtLeast "3.14" yes;

      SQUASHFS_FILE_DIRECT         = whenAtLeast "3.13" yes;
      SQUASHFS_DECOMP_MULTI_PERCPU = whenAtLeast "3.13" yes;
      SQUASHFS_XATTR               = yes;
      SQUASHFS_ZLIB                = yes;
      SQUASHFS_LZO                 = yes;
      SQUASHFS_XZ                  = yes;
      SQUASHFS_LZ4                 = whenAtLeast "3.19" yes;

      DEVTMPFS = yes;
    };

    security = {
      STRICT_DEVMEM = yes; # Filter access to /dev/mem

      DEVKMEM = when (!grsecurity) no; # Disable /dev/kmem

      CC_STACKPROTECTOR         = option (whenOlder   "3.14" yes); # Detect buffer overflows on the stack
      CC_STACKPROTECTOR_REGULAR = option (whenAtLeast "3.14" yes);

      USER_NS = whenAtLeast "3.12" yes; # Support for user namespaces

      SECURITY_APPARMOR         = yes;
      DEFAULT_SECURITY_APPARMOR = yes;

      AUDIT_LOGINUID_IMMUTABLE = whenBetween "3.3" "3.13" yes;
    };

    microcode = {
      MICROCODE       = yes;
      MICROCODE_INTEL = yes;
      MICROCODE_AMD   = yes;

      MICROCODE_EARLY       = whenBetween "3.11" "4.4" yes;
      MICROCODE_INTEL_EARLY = whenBetween "3.11" "4.4" yes;
      MICROCODE_AMD_EARLY   = whenBetween "3.11" "4.4" yes;
    };

    container = {
      NAMESPACES     = option yes; #  Required by 'unshare' used by 'nixos-install'
      RT_GROUP_SCHED = option yes;
      CGROUP_DEVICE  = option yes;

      MEMCG                    = whenAtLeast "3.6" yes;
      MEMCG_SWAP               = whenAtLeast "3.6" yes;
      CGROUP_MEM_RES_CTLR      = whenOlder "3.6" yes;
      CGROUP_MEM_RES_CTLR_SWAP = whenOlder "3.6" yes;
      
      DEVPTS_MULTIPLE_INSTANCES = yes;
      BLK_DEV_THROTTLING        = yes;
      CFQ_GROUP_IOSCHED         = yes;
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
      UPROBE_EVENT          = whenAtLeast "3.10" yes;
      FUNCTION_PROFILER     = yes;
      RING_BUFFER_BENCHMARK = no;
    };

    virtualisation = {
      PARAVIRT = option yes;

      HYPERVISOR_GUEST =         when (!grsecurity && versionAtLeast version "3.10") yes;
      PARAVIRT_GUEST   = option (when (!grsecurity && versionOlder   version "3.10") yes);

      KVM_APIC_ARCHITECTURE             = yes;
      KVM_ASYNC_PF                      = yes;
      KVM_CLOCK                         = option (whenOlder   "3.7"  yes);
      KVM_COMPAT                        = option (whenAtLeast "4.0"  yes);
      KVM_DEVICE_ASSIGNMENT             = option (whenAtLeast "3.10" yes);
      KVM_GENERIC_DIRTYLOG_READ_PROTECT = whenAtLeast "4.0"  yes;
      KVM_GUEST                         = when (!grsecurity) yes;
      KVM_MMIO                          = yes;
      KVM_VFIO                          = whenAtLeast "3.13" yes;

      XEN = option yes;

      # XXX: why isn't this in the xen-dom0 conditional section below?
      XEN_DOM0 = option yes;

      HIGHMEM64G = option (when (!is64bit) yes); # We nneed 64 GB (PAE) support for Xen guest support.

      VFIO_PCI_VGA = when (versionAtLeast version "3.9" && is64bit) yes;

      KSM = yes;
      VIRT_DRIVERS = yes;
    };

    xen-dom0 = optionalAttrs (versionAtLeast version "3.18" && xen_dom0) {
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
    };

    media = {
      MEDIA_DIGITAL_TV_SUPPORT = whenAtLeast "3.6" yes;
      MEDIA_CAMERA_SUPPORT     = whenAtLeast "3.6" yes;
      MEDIA_RC_SUPPORT         = whenAtLeast "3.6" yes;

      MEDIA_USB_SUPPORT = whenAtLeast "3.7" yes;
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
      ZSMALLOC = whenAtLeast "3.4" yes;
      ZRAM     = module;
    };

    brcmfmac = {
      # Enable PCIe and USB for the brcmfmac driver
      BRCMFMAC_USB  = option yes;
      BRCMFMAC_PCIE = option yes;
    };

    x2apic = {
      X86_X2APIC = when (system == "x86_64-linux") yes;
      IRQ_REMAP  = when (system == "x86_64-linux") yes;
    };

    misc = {
      PM_TRACE_RTC         = no; # Disable some expensive (?) features.
      ACCESSIBILITY        = yes; # Accessibility support
      AUXDISPLAY           = yes; # Auxiliary Display support
      DONGLE               = yes; # Serial dongle support
      HIPPI                = yes;
      MTD_COMPLEX_MAPPINGS = yes; # needed for many devices
      NET_POCKET           = whenOlder "3.2" yes; # enable pocket and portable adapters    
      
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

      BLK_DEV_CMD640_ENHANCED = yes; # CMD640 enhanced support
      BLK_DEV_IDEACPI         = yes; # IDE ACPI support
      BLK_DEV_INTEGRITY       = yes;

      BSD_PROCESS_ACCT_V3 = yes;

      BT_HCIUART_BCSP = option yes;
      BT_HCIUART_H4   = option yes; # UART (H4) protocol support
      BT_HCIUART_LL   = option yes;
      BT_RFCOMM_TTY   = option (whenAtLeast "3.4" yes); # RFCOMM TTY support

      DMAR = option (whenOlder "3.1" no); # experimental

      DVB_DYNAMIC_MINORS = option yes; # we use udev

      EFI_STUB = whenAtLeast "3.3" yes; # EFI bootloader in the bzImage itself

      FHANDLE      = yes; # used by systemd
      FUSION       = yes; # Fusion MPT device support
      IDE_GD_ATAPI = yes; # ATAPI floppy support
      IRDA_ULTRA   = yes; # Ultra (connectionless) protocol

      JOYSTICK_IFORCE_232 = option yes; # I-Force Serial joysticks and wheels
      JOYSTICK_IFORCE_USB = option yes; # I-Force USB joysticks and wheels
      JOYSTICK_XPAD_FF    = option yes; # X-Box gamepad rumble support
      JOYSTICK_XPAD_LEDS  = option yes; # LED Support for Xbox360 controller 'BigX' LED
      
      LDM_PARTITION         = yes; # Windows Logical Disk Manager (Dynamic Disk) support
      LEDS_TRIGGER_IDE_DISK = yes; # LED IDE Disk Trigger
      LOGIRUMBLEPAD2_FF     = yes; # Logitech Rumblepad 2 force feedback
      LOGO                  = no; # not needed
      MEDIA_ATTACH          = yes;
      MEGARAID_NEWGEN       = yes;

      MLX4_EN_VXLAN = whenAtLeast "3.15" yes;

      MODVERSIONS        = yes;
      MOUSE_PS2_ELANTECH = yes; # Elantech PS/2 protocol extension
      MTRR_SANITIZER     = yes;
      NET_FC             = yes; # Fibre Channel driver support
      PINCTRL_BAYTRAIL   = whenAtLeast "3.11" yes; # GPIO on Intel Bay Trail, for some Chromebook internal eMMC disks

      PPP_MULTILINK = yes; # PPP multilink support
      PPP_FILTER    = yes;
      
      REGULATOR  = yes; # Voltage and Current Regulator Support
      RC_DEVICES = option (whenAtLeast "3.6" yes); # Enable IR devices

      RT2800USB_RT55XX = whenAtLeast "3.10" yes;

      SCSI_LOGGING = yes; # SCSI logging facility
      SERIAL_8250  = yes; # 8250/16550 and compatible serial support
      
      SLIP_COMPRESSED = yes; # CSLIP compressed headers
      SLIP_SMART      = yes;

      HWMON         = yes;
      THERMAL_HWMON = yes; # Hardware monitoring support
      UEVENT_HELPER = whenAtLeast "3.15" no;

      X86_CHECK_BIOS_CORRUPTION = yes;
      X86_MCE                   = yes;

      BINFMT_SCRIPT = whenAtLeast "3.10" yes;

      # Disable the firmware helper fallback, udev doesn't implement it any more
      FW_LOADER_USER_HELPER_FALLBACK = option no;
    };
  };
in generateKConf (flattenKConf options)
