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
{ lib, stdenv, version

, features ? {}
}:

with lib;
with lib.kernel;
with (lib.kernel.whenHelpers version);

let


  # configuration items have to be part of a subattrs
  flattenKConf = nested: mapAttrs (name: values: if length values == 1 then head values else throw "duplicate kernel configuration option: ${name}") (zipAttrs (attrValues nested));

  whenPlatformHasEBPFJit =
    mkIf (stdenv.hostPlatform.isAarch32 ||
          stdenv.hostPlatform.isAarch64 ||
          stdenv.hostPlatform.isx86_64 ||
          (stdenv.hostPlatform.isPower && stdenv.hostPlatform.is64bit) ||
          (stdenv.hostPlatform.isMips && stdenv.hostPlatform.is64bit));

  options = {

    debug = {
      # Necessary for BTF
      DEBUG_INFO                = mkMerge [
        (whenOlder "5.2" (if (features.debug or false) then yes else no))
        (whenBetween "5.2" "5.18" yes)
      ];
      DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT = whenAtLeast "5.18" yes;
      # Reduced debug info conflict with BTF and have been enabled in
      # aarch64 defconfig since 5.13
      DEBUG_INFO_REDUCED        = whenAtLeast "5.13" (option no);
      DEBUG_INFO_BTF            = whenAtLeast "5.2" (option yes);
      # Allow loading modules with mismatched BTFs
      # FIXME: figure out how to actually make BTFs reproducible instead
      # See https://github.com/NixOS/nixpkgs/pull/181456 for details.
      MODULE_ALLOW_BTF_MISMATCH = whenAtLeast "5.18" (option yes);
      BPF_LSM                   = whenAtLeast "5.7" (option yes);
      DEBUG_KERNEL              = yes;
      DEBUG_DEVRES              = no;
      DYNAMIC_DEBUG             = yes;
      DEBUG_STACK_USAGE         = no;
      RCU_TORTURE_TEST          = no;
      SCHEDSTATS                = yes;
      DETECT_HUNG_TASK          = yes;
      CRASH_DUMP                = option no;
      # Easier debugging of NFS issues.
      SUNRPC_DEBUG              = yes;
      # Provide access to tunables like sched_migration_cost_ns
      SCHED_DEBUG               = yes;

      # Count IRQ and steal CPU time separately
      IRQ_TIME_ACCOUNTING       = yes;
      PARAVIRT_TIME_ACCOUNTING  = yes;

      # Enable CPU lockup detection
      LOCKUP_DETECTOR           = yes;
      SOFTLOCKUP_DETECTOR       = yes;
      HARDLOCKUP_DETECTOR       = yes;

      # Enable streaming logs to a remote device over a network
      NETCONSOLE                = module;
      NETCONSOLE_DYNAMIC        = yes;

      # Export known printks in debugfs
      PRINTK_INDEX              = whenAtLeast "5.15" yes;
    };

    power-management = {
      CPU_FREQ_DEFAULT_GOV_SCHEDUTIL   = yes;
      CPU_FREQ_GOV_SCHEDUTIL           = yes;
      PM_ADVANCED_DEBUG                = yes;
      PM_WAKELOCKS                     = yes;
      POWERCAP                         = yes;
      # ACPI Firmware Performance Data Table Support
      ACPI_FPDT                        = whenAtLeast "5.12" (option yes);
      # ACPI Heterogeneous Memory Attribute Table Support
      ACPI_HMAT                        = whenAtLeast "5.2" (option yes);
      # ACPI Platform Error Interface
      ACPI_APEI                        = (option yes);
      # APEI Generic Hardware Error Source
      ACPI_APEI_GHES                   = (option yes);

      # Enable lazy RCUs for power savings:
      # https://lore.kernel.org/rcu/20221019225138.GA2499943@paulmck-ThinkPad-P17-Gen-1/
      # RCU_LAZY depends on RCU_NOCB_CPU depends on NO_HZ_FULL
      # depends on HAVE_VIRT_CPU_ACCOUNTING_GEN depends on 64BIT,
      # so we can't force-enable this
      RCU_LAZY                         = whenAtLeast "6.2" (option yes);

      # Auto suspend Bluetooth devices at idle
      BT_HCIBTUSB_AUTOSUSPEND          = yes;

      # Expose cpufreq stats in sysfs
      CPU_FREQ_STAT                    = yes;

      # Enable CPU energy model for scheduling
      ENERGY_MODEL                     = whenAtLeast "5.0" yes;

      # Enable thermal interface netlink API
      THERMAL_NETLINK                  = whenAtLeast "5.9" yes;

      # Prefer power-efficient workqueue implementation to per-CPU workqueues,
      # which is slightly slower, but improves battery life.
      # This is opt-in per workqueue, and can be disabled globally with a kernel command line option.
      WQ_POWER_EFFICIENT_DEFAULT       = yes;

      # Default SATA link power management to "medium with device initiated PM"
      # for some extra power savings.
      SATA_MOBILE_LPM_POLICY           = whenAtLeast "5.18" (freeform "3");

      # GPIO power management
      POWER_RESET_GPIO                 = option yes;
      POWER_RESET_GPIO_RESTART         = option yes;

      # Enable Pulse-Width-Modulation support, commonly used for fan and backlight.
      PWM                              = yes;
    } // optionalAttrs (stdenv.hostPlatform.isx86) {
      INTEL_IDLE                       = yes;
      INTEL_RAPL                       = whenAtLeast "5.3" module;
      X86_INTEL_LPSS                   = yes;
      X86_INTEL_PSTATE                 = yes;
      X86_AMD_PSTATE                   = whenAtLeast "5.17" yes;
      # Intel DPTF (Dynamic Platform and Thermal Framework) Support
      ACPI_DPTF                        = whenAtLeast "5.10" yes;

      # Required to bring up some Bay Trail devices properly
      I2C                              = yes;
      I2C_DESIGNWARE_PLATFORM          = yes;
      PMIC_OPREGION                    = whenAtLeast "5.10" yes;
      INTEL_SOC_PMIC                   = whenAtLeast "5.10" yes;
      BYTCRC_PMIC_OPREGION             = whenAtLeast "5.10" yes;
      CHTCRC_PMIC_OPREGION             = whenAtLeast "5.10" yes;
      XPOWER_PMIC_OPREGION             = whenAtLeast "5.10" yes;
      BXT_WC_PMIC_OPREGION             = whenAtLeast "5.10" yes;
      INTEL_SOC_PMIC_CHTWC             = whenAtLeast "5.10" yes;
      CHT_WC_PMIC_OPREGION             = whenAtLeast "5.10" yes;
      INTEL_SOC_PMIC_CHTDC_TI          = whenAtLeast "5.10" yes;
      CHT_DC_TI_PMIC_OPREGION          = whenAtLeast "5.10" yes;
      MFD_TPS68470                     = whenBetween "5.10" "5.13" yes;
      TPS68470_PMIC_OPREGION           = whenAtLeast "5.10" yes;

      # Enable Intel thermal hardware feedback
      INTEL_HFI_THERMAL                = whenAtLeast "5.18" yes;
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
      X86_GENERIC = mkIf (stdenv.hostPlatform.system == "i686-linux") yes;
      # Optimize with -O2, not -Os
      CC_OPTIMIZE_FOR_SIZE = no;
    };

    memory = {
      DAMON = whenAtLeast "5.15" yes;
      DAMON_VADDR = whenAtLeast "5.15" yes;
      DAMON_PADDR = whenAtLeast "5.16" yes;
      DAMON_SYSFS = whenAtLeast "5.18" yes;
      DAMON_DBGFS = whenBetween "5.15" "6.9" yes;
      DAMON_RECLAIM = whenAtLeast "5.16" yes;
      DAMON_LRU_SORT = whenAtLeast "6.0" yes;
      # Support recovering from memory failures on systems with ECC and MCA recovery.
      MEMORY_FAILURE = yes;

      # Collect ECC errors and retire pages that fail too often
      RAS_CEC                   = yes;
    } // optionalAttrs (stdenv.is32bit) {
      # Enable access to the full memory range (aka PAE) on 32-bit architectures
      # This check isn't super accurate but it's close enough
      HIGHMEM                   = option yes;
      BOUNCE                    = option yes;
    };

    memtest = {
      MEMTEST = yes;
    };

    # Include the CFQ I/O scheduler in the kernel, rather than as a
    # module, so that the initrd gets a good I/O scheduler.
    scheduler = {
      IOSCHED_CFQ = whenOlder "5.0" yes; # Removed in 5.0-RC1
      BLK_CGROUP  = yes; # required by CFQ"
      BLK_CGROUP_IOLATENCY = yes;
      BLK_CGROUP_IOCOST = whenAtLeast "5.4" yes;
      IOSCHED_DEADLINE = whenOlder "5.0" yes; # Removed in 5.0-RC1
      MQ_IOSCHED_DEADLINE = yes;
      BFQ_GROUP_IOSCHED = yes;
      MQ_IOSCHED_KYBER = yes;
      IOSCHED_BFQ = module;
      # Enable CPU utilization clamping for RT tasks
      UCLAMP_TASK = whenAtLeast "5.3" yes;
      UCLAMP_TASK_GROUP = whenAtLeast "5.4" yes;
    };


    timer = {
      # Enable Full Dynticks System.
      # NO_HZ_FULL depends on HAVE_VIRT_CPU_ACCOUNTING_GEN depends on 64BIT
      NO_HZ_FULL = mkIf stdenv.is64bit yes;
    };

    # Enable NUMA.
    numa = {
      NUMA  = option yes;
      NUMA_BALANCING = option yes;
    };

    networking = {
      NET                = yes;
      IP_ADVANCED_ROUTER = yes;
      IP_PNP             = no;
      IP_ROUTE_MULTIPATH = yes;
      IP_VS_PROTO_TCP    = yes;
      IP_VS_PROTO_UDP    = yes;
      IP_VS_PROTO_ESP    = yes;
      IP_VS_PROTO_AH     = yes;
      IP_VS_IPV6         = yes;
      IP_DCCP_CCID3      = no; # experimental
      CLS_U32_PERF       = yes;
      CLS_U32_MARK       = yes;
      BPF_JIT            = whenPlatformHasEBPFJit yes;
      BPF_JIT_ALWAYS_ON  = whenPlatformHasEBPFJit no; # whenPlatformHasEBPFJit yes; # see https://github.com/NixOS/nixpkgs/issues/79304
      HAVE_EBPF_JIT      = whenPlatformHasEBPFJit yes;
      BPF_STREAM_PARSER  = yes;
      XDP_SOCKETS        = yes;
      XDP_SOCKETS_DIAG   = whenAtLeast "5.1" yes;
      WAN                = yes;
      TCP_CONG_ADVANCED  = yes;
      TCP_CONG_CUBIC     = yes; # This is the default congestion control algorithm since 2.6.19
      # Required by systemd per-cgroup firewalling
      CGROUP_BPF                  = option yes;
      CGROUP_NET_PRIO             = yes; # Required by systemd
      IP_ROUTE_VERBOSE            = yes;
      IP_MROUTE_MULTIPLE_TABLES   = yes;
      IP_MULTICAST                = yes;
      IP_MULTIPLE_TABLES          = yes;
      IPV6                        = yes;
      IPV6_ROUTER_PREF            = yes;
      IPV6_ROUTE_INFO             = yes;
      IPV6_OPTIMISTIC_DAD         = yes;
      IPV6_MULTIPLE_TABLES        = yes;
      IPV6_SUBTREES               = yes;
      IPV6_MROUTE                 = yes;
      IPV6_MROUTE_MULTIPLE_TABLES = yes;
      IPV6_PIMSM_V2               = yes;
      IPV6_FOU_TUNNEL             = module;
      IPV6_SEG6_LWTUNNEL          = yes;
      IPV6_SEG6_HMAC              = yes;
      IPV6_SEG6_BPF               = yes;
      NET_CLS_BPF                 = module;
      NET_ACT_BPF                 = module;
      NET_SCHED                   = yes;
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
      KEY_DH_OPERATIONS = yes;

      # needed for nftables
      # Networking Options
      NETFILTER                   = yes;
      NETFILTER_ADVANCED          = yes;
      # Core Netfilter Configuration
      NF_CONNTRACK_ZONES          = yes;
      NF_CONNTRACK_EVENTS         = yes;
      NF_CONNTRACK_TIMEOUT        = yes;
      NF_CONNTRACK_TIMESTAMP      = yes;
      NETFILTER_NETLINK_GLUE_CT   = yes;
      NF_TABLES_INET              = yes;
      NF_TABLES_NETDEV            = yes;
      NFT_REJECT_NETDEV           = whenAtLeast "5.11" module;

      # IP: Netfilter Configuration
      NF_TABLES_IPV4              = yes;
      NF_TABLES_ARP               = yes;
      # IPv6: Netfilter Configuration
      NF_TABLES_IPV6              = yes;
      # Bridge Netfilter Configuration
      NF_TABLES_BRIDGE            = mkMerge [ (whenOlder "5.3" yes)
                                              (whenAtLeast "5.3" module) ];
      # Expose some debug info
      NF_CONNTRACK_PROCFS         = yes;
      NF_FLOW_TABLE_PROCFS        = whenAtLeast "6.0" yes;

      # needed for `dropwatch`
      # Builtin-only since https://github.com/torvalds/linux/commit/f4b6bcc7002f0e3a3428bac33cf1945abff95450
      NET_DROP_MONITOR = yes;

      # needed for ss
      # Use a lower priority to allow these options to be overridden in hardened/config.nix
      INET_DIAG         = mkDefault module;
      INET_TCP_DIAG     = mkDefault module;
      INET_UDP_DIAG     = mkDefault module;
      INET_RAW_DIAG     = mkDefault module;
      INET_DIAG_DESTROY = mkDefault yes;

      # enable multipath-tcp
      MPTCP           = whenAtLeast "5.6" yes;
      MPTCP_IPV6      = whenAtLeast "5.6" yes;
      INET_MPTCP_DIAG = whenAtLeast "5.9" (mkDefault module);

      # Kernel TLS
      TLS         = module;
      TLS_DEVICE  = yes;

      # infiniband
      INFINIBAND = module;
      INFINIBAND_IPOIB = module;
      INFINIBAND_IPOIB_CM = yes;

      # Enable debugfs for wireless drivers
      CFG80211_DEBUGFS = yes;
      MAC80211_DEBUGFS = yes;
    } // optionalAttrs (stdenv.hostPlatform.system == "aarch64-linux") {
      # Not enabled by default, hides modules behind it
      NET_VENDOR_MEDIATEK = yes;
      # Enable SoC interface for MT7915 module, required for MT798X.
      MT7986_WMAC = whenBetween "5.18" "6.6" yes;
      MT798X_WMAC = whenAtLeast "6.6" yes;
    };

    wireless = {
      CFG80211_WEXT               = option yes; # Without it, ipw2200 drivers don't build
      IPW2100_MONITOR             = option yes; # support promiscuous mode
      IPW2200_MONITOR             = option yes; # support promiscuous mode
      HOSTAP_FIRMWARE             = whenOlder "6.8" (option yes); # Support downloading firmware images with Host AP driver
      HOSTAP_FIRMWARE_NVRAM       = whenOlder "6.8" (option yes);
      MAC80211_MESH               = option yes; # Enable 802.11s (mesh networking) support
      ATH9K_PCI                   = option yes; # Detect Atheros AR9xxx cards on PCI(e) bus
      ATH9K_AHB                   = option yes; # Ditto, AHB bus
      # The description of this option makes it sound dangerous or even illegal
      # But OpenWRT enables it by default: https://github.com/openwrt/openwrt/blob/master/package/kernel/mac80211/Makefile#L55
      # At the time of writing (25-06-2023): this is only used in a "correct" way by ath drivers for initiating DFS radiation
      # for "certified devices"
      EXPERT                      = option yes; # this is needed for offering the certification option
      RFKILL_INPUT                = option yes; # counteract an undesired effect of setting EXPERT
      CFG80211_CERTIFICATION_ONUS = option yes;
      # DFS: "Dynamic Frequency Selection" is a spectrum-sharing mechanism that allows
      # you to use certain interesting frequency when your local regulatory domain mandates it.
      # ATH drivers hides the feature behind this option and makes hostapd works with DFS frequencies.
      # OpenWRT enables it too: https://github.com/openwrt/openwrt/blob/master/package/kernel/mac80211/ath.mk#L42
      ATH9K_DFS_CERTIFIED         = option yes;
      ATH10K_DFS_CERTIFIED        = option yes;
      B43_PHY_HT                  = option yes;
      BCMA_HOST_PCI               = option yes;
      RTW88                       = whenAtLeast "5.2" module;
      RTW88_8822BE                = mkMerge [ (whenBetween "5.2" "5.8" yes) (whenAtLeast "5.8" module) ];
      RTW88_8822CE                = mkMerge [ (whenBetween "5.2" "5.8" yes) (whenAtLeast "5.8" module) ];
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
      FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER = yes;
      FRAMEBUFFER_CONSOLE_ROTATION = yes;
      FRAMEBUFFER_CONSOLE_DETECT_PRIMARY = yes;
      FB_GEODE            = mkIf (stdenv.hostPlatform.system == "i686-linux") yes;
      # Use simplefb on older kernels where we don't have simpledrm (enabled below)
      FB_SIMPLE           = whenOlder "5.15" yes;
      DRM_FBDEV_EMULATION = yes;
    };

    fonts = {
      FONTS = yes;
      # Default fonts enabled if FONTS is not set
      FONT_8x8 = yes;
      FONT_8x16 = yes;
      # High DPI font
      FONT_TER16x32 = whenAtLeast "5.0" yes;
    };

    video = let
      whenHasDevicePrivate = mkIf (!stdenv.isx86_32 && versionAtLeast version "5.1");
    in {
      # compile in DRM so simpledrm can load before initrd if necessary
      AGP = yes;
      DRM = yes;

      DRM_LEGACY = whenOlder "6.8" no;

      NOUVEAU_LEGACY_CTX_SUPPORT = whenBetween "5.2" "6.3" no;

      # Enable simpledrm and use it for generic framebuffer
      # Technically added in 5.14, but adding more complex configuration is not worth it
      DRM_SIMPLEDRM = whenAtLeast "5.15" yes;
      SYSFB_SIMPLEFB = whenAtLeast "5.15" yes;

      # Allow specifying custom EDID on the kernel command line
      DRM_LOAD_EDID_FIRMWARE = yes;
      VGA_SWITCHEROO         = yes; # Hybrid graphics support
      DRM_GMA500             = whenAtLeast "5.12" module;
      DRM_GMA600             = whenOlder "5.13" yes;
      DRM_GMA3600            = whenOlder "5.12" yes;
      DRM_VMWGFX_FBCON       = whenOlder "6.2" yes;
      # (experimental) amdgpu support for verde and newer chipsets
      DRM_AMDGPU_SI = yes;
      # (stable) amdgpu support for bonaire and newer chipsets
      DRM_AMDGPU_CIK = yes;
      # Allow device firmware updates
      DRM_DP_AUX_CHARDEV = whenOlder "6.10" yes;
      DRM_DISPLAY_DP_AUX_CHARDEV = whenAtLeast "6.10" yes;
      # amdgpu display core (DC) support
      DRM_AMD_DC_DCN1_0 = whenOlder "5.6" yes;
      DRM_AMD_DC_DCN2_0 = whenBetween "5.3" "5.6" yes;
      DRM_AMD_DC_DCN2_1 = whenBetween "5.4" "5.6" yes;
      DRM_AMD_DC_DCN3_0 = whenBetween "5.9" "5.11" yes;
      DRM_AMD_DC_DCN = whenBetween "5.11" "6.4" yes;
      DRM_AMD_DC_FP = whenAtLeast "6.4" yes;
      DRM_AMD_DC_HDCP = whenBetween "5.5" "6.4" yes;
      DRM_AMD_DC_SI = whenAtLeast "5.10" yes;

      # Enable AMD Audio Coprocessor support for HDMI outputs
      DRM_AMD_ACP = yes;

      # Enable AMD secure display when available
      DRM_AMD_SECURE_DISPLAY = whenAtLeast "5.13" yes;

      # Enable new firmware (and by extension NVK) for compatible hardware on Nouveau
      DRM_NOUVEAU_GSP_DEFAULT = whenAtLeast "6.8" yes;

      # Enable Nouveau shared virtual memory (used by OpenCL)
      DEVICE_PRIVATE = whenHasDevicePrivate yes;
      DRM_NOUVEAU_SVM = whenHasDevicePrivate yes;

      # Enable HDMI-CEC receiver support
      RC_CORE = yes;
      MEDIA_CEC_RC = whenAtLeast "5.10" yes;

      # Enable CEC over DisplayPort
      DRM_DP_CEC = whenOlder "6.10" yes;
      DRM_DISPLAY_DP_AUX_CEC = whenAtLeast "6.10" yes;
    } // optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux") {
      # Intel GVT-g graphics virtualization supports 64-bit only
      DRM_I915_GVT = yes;
      DRM_I915_GVT_KVMGT = module;
      # Enable Hyper-V Synthetic DRM Driver
      DRM_HYPERV = whenAtLeast "5.14" module;
    } // optionalAttrs (stdenv.hostPlatform.system == "aarch64-linux") {
      # enable HDMI-CEC on RPi boards
      DRM_VC4_HDMI_CEC = yes;
    };

    # Enables Rust support in the Linux kernel. This is currently not enabled by default, because it occasionally requires
    # patching the Linux kernel for the specific Rust toolchain in nixpkgs. These patches usually take a bit
    # of time to appear and this would hold up Linux kernel and Rust toolchain updates.
    #
    # Once Rust in the kernel has more users, we can reconsider enabling it by default.
    rust = optionalAttrs ((features.rust or false) && versionAtLeast version "6.7") {
      RUST = yes;
      GCC_PLUGINS = no;
    };

    sound = {
      SND_DYNAMIC_MINORS  = yes;
      SND_AC97_POWER_SAVE = yes; # AC97 Power-Saving Mode
      # 10s for the idle timeout, Fedora does 1, Arch does 10.
      # The kernel says we should do 10.
      # Read: https://docs.kernel.org/sound/designs/powersave.html
      SND_AC97_POWER_SAVE_DEFAULT = freeform "10";
      SND_HDA_POWER_SAVE_DEFAULT = freeform "10";
      SND_HDA_INPUT_BEEP  = yes; # Support digital beep via input layer
      SND_HDA_RECONFIG    = yes; # Support reconfiguration of jack functions
      # Support configuring jack functions via fw mechanism at boot
      SND_HDA_PATCH_LOADER = yes;
      SND_HDA_CODEC_CA0132_DSP = whenOlder "5.7" yes; # Enable DSP firmware loading on Creative Soundblaster Z/Zx/ZxR/Recon
      SND_OSSEMUL         = yes;
      SND_USB_CAIAQ_INPUT = yes;
      SND_USB_AUDIO_MIDI_V2 = whenAtLeast "6.5" yes;
    # Enable Sound Open Firmware support
    } // optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux" &&
                        versionAtLeast version "5.5") {
      SND_SOC_INTEL_SOUNDWIRE_SOF_MACH       = whenAtLeast "5.10" module;
      SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES = whenAtLeast "5.10" yes; # dep of SOF_MACH
      SND_SOC_SOF_INTEL_SOUNDWIRE_LINK = whenBetween "5.10" "5.11" yes; # dep of SOF_MACH
      SND_SOC_SOF_TOPLEVEL              = yes;
      SND_SOC_SOF_ACPI                  = module;
      SND_SOC_SOF_PCI                   = module;
      SND_SOC_SOF_APOLLOLAKE            = whenAtLeast "5.12" module;
      SND_SOC_SOF_APOLLOLAKE_SUPPORT    = whenOlder "5.12" yes;
      SND_SOC_SOF_CANNONLAKE            = whenAtLeast "5.12" module;
      SND_SOC_SOF_CANNONLAKE_SUPPORT    = whenOlder "5.12" yes;
      SND_SOC_SOF_COFFEELAKE            = whenAtLeast "5.12" module;
      SND_SOC_SOF_COFFEELAKE_SUPPORT    = whenOlder "5.12" yes;
      SND_SOC_SOF_COMETLAKE             = whenAtLeast "5.12" module;
      SND_SOC_SOF_COMETLAKE_H_SUPPORT   = whenOlder "5.8" yes;
      SND_SOC_SOF_COMETLAKE_LP_SUPPORT  = whenOlder "5.12" yes;
      SND_SOC_SOF_ELKHARTLAKE           = whenAtLeast "5.12" module;
      SND_SOC_SOF_ELKHARTLAKE_SUPPORT   = whenOlder "5.12" yes;
      SND_SOC_SOF_GEMINILAKE            = whenAtLeast "5.12" module;
      SND_SOC_SOF_GEMINILAKE_SUPPORT    = whenOlder "5.12" yes;
      SND_SOC_SOF_HDA_AUDIO_CODEC       = yes;
      SND_SOC_SOF_HDA_COMMON_HDMI_CODEC = whenOlder "5.7" yes;
      SND_SOC_SOF_HDA_LINK              = yes;
      SND_SOC_SOF_ICELAKE               = whenAtLeast "5.12" module;
      SND_SOC_SOF_ICELAKE_SUPPORT       = whenOlder "5.12" yes;
      SND_SOC_SOF_INTEL_TOPLEVEL        = yes;
      SND_SOC_SOF_JASPERLAKE            = whenAtLeast "5.12" module;
      SND_SOC_SOF_JASPERLAKE_SUPPORT    = whenOlder "5.12" yes;
      SND_SOC_SOF_MERRIFIELD            = whenAtLeast "5.12" module;
      SND_SOC_SOF_MERRIFIELD_SUPPORT    = whenOlder "5.12" yes;
      SND_SOC_SOF_TIGERLAKE             = whenAtLeast "5.12" module;
      SND_SOC_SOF_TIGERLAKE_SUPPORT     = whenOlder "5.12" yes;
    };

    usb = {
      USB                  = yes; # compile USB core into kernel, so we can use USB_SERIAL_CONSOLE before modules

      USB_EHCI_ROOT_HUB_TT = yes; # Root Hub Transaction Translators
      USB_EHCI_TT_NEWSCHED = yes; # Improved transaction translator scheduling
      USB_HIDDEV = yes; # USB Raw HID Devices (like monitor controls and Uninterruptable Power Supplies)

      # default to dual role mode
      USB_DWC2_DUAL_ROLE = yes;
      USB_DWC3_DUAL_ROLE = yes;
    };

    usb-serial = {
      USB_SERIAL                  = yes;
      USB_SERIAL_GENERIC          = yes; # USB Generic Serial Driver
      USB_SERIAL_CONSOLE          = yes; # Allow using USB serial adapter as console
      U_SERIAL_CONSOLE            = whenAtLeast "5.10" yes; # Allow using USB gadget as console
    };

    # Filesystem options - in particular, enable extended attributes and
    # ACLs for all filesystems that support them.
    filesystem = {
      FANOTIFY                    = yes;
      FANOTIFY_ACCESS_PERMISSIONS = yes;

      TMPFS           = yes;
      TMPFS_POSIX_ACL = yes;
      FS_ENCRYPTION   = if (versionAtLeast version "5.1") then yes else option module;

      EXT2_FS_XATTR     = yes;
      EXT2_FS_POSIX_ACL = yes;
      EXT2_FS_SECURITY  = yes;

      EXT3_FS_POSIX_ACL = yes;
      EXT3_FS_SECURITY  = yes;

      EXT4_FS_POSIX_ACL = yes;
      EXT4_FS_SECURITY  = yes;
      EXT4_ENCRYPTION   = whenOlder "5.1" yes;

      NTFS_FS            = whenBetween "5.15" "6.9" no;
      NTFS3_LZX_XPRESS   = whenAtLeast "5.15" yes;
      NTFS3_FS_POSIX_ACL = whenAtLeast "5.15" yes;

      REISERFS_FS_XATTR     = option yes;
      REISERFS_FS_POSIX_ACL = option yes;
      REISERFS_FS_SECURITY  = option yes;

      JFS_POSIX_ACL = option yes;
      JFS_SECURITY  = option yes;

      XFS_QUOTA     = option yes;
      XFS_POSIX_ACL = option yes;
      XFS_RT        = option yes; # XFS Realtime subvolume support
      XFS_ONLINE_SCRUB = option yes;

      OCFS2_DEBUG_MASKLOG = option no;

      BTRFS_FS_POSIX_ACL = yes;

      BCACHEFS_QUOTA = whenAtLeast "6.7" (option yes);
      BCACHEFS_POSIX_ACL = whenAtLeast "6.7" (option yes);

      UBIFS_FS_ADVANCED_COMPR = option yes;

      F2FS_FS             = module;
      F2FS_FS_SECURITY    = option yes;
      F2FS_FS_ENCRYPTION  = whenOlder "5.1" yes;
      F2FS_FS_COMPRESSION = whenAtLeast "5.6" yes;
      UDF_FS              = module;

      NFSD_V2_ACL            = whenOlder "5.15" yes;
      NFSD_V3                = whenOlder "5.15" yes;
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
      CIFS_WEAK_PW_HASH = whenOlder "5.15" yes;
      CIFS_UPCALL       = yes;
      CIFS_ACL          = whenOlder "5.3" yes;
      CIFS_DFS_UPCALL   = yes;

      CEPH_FSCACHE      = yes;
      CEPH_FS_POSIX_ACL = yes;

      SQUASHFS_FILE_DIRECT         = yes;
      SQUASHFS_DECOMP_MULTI_PERCPU = whenOlder "6.2" yes;
      SQUASHFS_CHOICE_DECOMP_BY_MOUNT = whenAtLeast "6.2" yes;
      SQUASHFS_XATTR               = yes;
      SQUASHFS_ZLIB                = yes;
      SQUASHFS_LZO                 = yes;
      SQUASHFS_XZ                  = yes;
      SQUASHFS_LZ4                 = yes;
      SQUASHFS_ZSTD                = yes;

      # Native Language Support modules, needed by some filesystems
      NLS              = yes;
      NLS_DEFAULT      = freeform "utf8";
      NLS_UTF8         = module;
      NLS_CODEPAGE_437 = module; # VFAT default for the codepage= mount option
      NLS_ISO8859_1    = module; # VFAT default for the iocharset= mount option

      # Needed to use the installation iso image. Not included in all defconfigs (e.g. arm64)
      ISO9660_FS = module;

      DEVTMPFS = yes;

      UNICODE = whenAtLeast "5.2" yes; # Casefolding support for filesystems
    };

    security = {
      FORTIFY_SOURCE                   = option yes;

      # https://googleprojectzero.blogspot.com/2019/11/bad-binder-android-in-wild-exploit.html
      DEBUG_LIST                       = yes;
      HARDENED_USERCOPY                = yes;
      RANDOMIZE_BASE                   = option yes;
      STRICT_DEVMEM                    = mkDefault yes; # Filter access to /dev/mem
      IO_STRICT_DEVMEM                 = mkDefault yes;
      SECURITY_SELINUX_BOOTPARAM_VALUE = whenOlder "5.1" (freeform "0"); # Disable SELinux by default
      # Prevent processes from ptracing non-children processes
      SECURITY_YAMA                    = option yes;
      # The goal of Landlock is to enable to restrict ambient rights (e.g. global filesystem access) for a set of processes.
      # This does not have any effect if a program does not support it
      SECURITY_LANDLOCK                = whenAtLeast "5.13" yes;
      DEVKMEM                          = whenOlder "5.13" no; # Disable /dev/kmem

      USER_NS                          = yes; # Support for user namespaces

      SECURITY_APPARMOR                = yes;
      DEFAULT_SECURITY_APPARMOR        = yes;

      RANDOM_TRUST_CPU                 = whenOlder "6.2" yes; # allow RDRAND to seed the RNG
      RANDOM_TRUST_BOOTLOADER          = whenOlder "6.2" (whenAtLeast "5.4" yes); # allow the bootloader to seed the RNG

      MODULE_SIG            = no; # r13y, generates a random key during build and bakes it in
      # Depends on MODULE_SIG and only really helps when you sign your modules
      # and enforce signatures which we don't do by default.
      SECURITY_LOCKDOWN_LSM = whenAtLeast "5.4" no;

      # provides a register of persistent per-UID keyrings, useful for encrypting storage pools in stratis
      PERSISTENT_KEYRINGS              = yes;
      # enable temporary caching of the last request_key() result
      KEYS_REQUEST_CACHE               = whenAtLeast "5.3" yes;
      # randomized slab caches
      RANDOM_KMALLOC_CACHES            = whenAtLeast "6.6" yes;

      # NIST SP800-90A DRBG modes - enabled by most distributions
      #   and required by some out-of-tree modules (ShuffleCake)
      #   This does not include the NSA-backdoored Dual-EC mode from the same NIST publication.
      CRYPTO_DRBG_HASH                 = yes;
      CRYPTO_DRBG_CTR                  = yes;

      # Enable KFENCE
      # See: https://docs.kernel.org/dev-tools/kfence.html
      KFENCE                           = whenAtLeast "5.12" yes;

      # Enable support for page poisoning. Still needs to be enabled on the command line to actually work.
      PAGE_POISONING                   = yes;

      # Enable stack smashing protections in schedule()
      # See: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v4.8&id=0d9e26329b0c9263d4d9e0422d80a0e73268c52f
      SCHED_STACK_END_CHECK            = yes;
    } // optionalAttrs stdenv.hostPlatform.isx86_64 {
      # Enable Intel SGX
      X86_SGX     = whenAtLeast "5.11" yes;
      # Allow KVM guests to load SGX enclaves
      X86_SGX_KVM = whenAtLeast "5.13" yes;

      # AMD Cryptographic Coprocessor (CCP)
      CRYPTO_DEV_CCP  = yes;
      # AMD SME
      AMD_MEM_ENCRYPT = yes;
      # AMD SEV and AMD SEV-SE
      KVM_AMD_SEV     = yes;
      # AMD SEV-SNP
      SEV_GUEST       = whenAtLeast "5.19" module;
      # Shadow stacks
      X86_USER_SHADOW_STACK = whenAtLeast "6.6" yes;

      # Mitigate straight line speculation at the cost of some file size
      SLS = whenBetween "5.17" "6.9" yes;
      MITIGATION_SLS = whenAtLeast "6.9" yes;
    };

    microcode = {
      MICROCODE       = yes;
      MICROCODE_INTEL = whenOlder "6.6" yes;
      MICROCODE_AMD   = whenOlder "6.6" yes;
      # Write Back Throttling
      # https://lwn.net/Articles/682582/
      # https://bugzilla.kernel.org/show_bug.cgi?id=12309#c655
      BLK_WBT    = yes;
      BLK_WBT_SQ = whenOlder "5.0" yes; # Removed in 5.0-RC1
      BLK_WBT_MQ = yes;
    };

    container = {
      NAMESPACES     = yes; #  Required by 'unshare' used by 'nixos-install'
      RT_GROUP_SCHED = no;
      CGROUP_DEVICE  = yes;
      CGROUP_HUGETLB = yes;
      CGROUP_PERF    = yes;
      CGROUP_RDMA    = yes;

      MEMCG                    = yes;
      MEMCG_SWAP               = whenOlder "6.1" yes;

      BLK_DEV_THROTTLING        = yes;
      CFQ_GROUP_IOSCHED         = whenOlder "5.0" yes; # Removed in 5.0-RC1
      CGROUP_PIDS               = yes;
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
      UPROBE_EVENTS         = option yes;
      BPF_SYSCALL           = yes;
      BPF_UNPRIV_DEFAULT_OFF = whenBetween "5.10" "5.16" yes;
      BPF_EVENTS            = yes;
      FUNCTION_PROFILER     = yes;
      RING_BUFFER_BENCHMARK = no;
    };

    perf = {
      # enable AMD Zen branch sampling if available
      PERF_EVENTS_AMD_BRS       = whenAtLeast "5.19" (option yes);
    };

    virtualisation = {
      PARAVIRT = option yes;

      HYPERVISOR_GUEST = yes;
      PARAVIRT_SPINLOCKS  = option yes;

      KVM_ASYNC_PF                      = yes;
      KVM_GENERIC_DIRTYLOG_READ_PROTECT = yes;
      KVM_GUEST                         = yes;
      KVM_MMIO                          = yes;
      KVM_VFIO                          = yes;
      KSM = yes;
      VIRT_DRIVERS = yes;
      # We need 64 GB (PAE) support for Xen guest support
      HIGHMEM64G = { optional = true; tristate = mkIf (!stdenv.is64bit) "y";};

      VFIO_PCI_VGA = mkIf stdenv.is64bit yes;

      UDMABUF = whenAtLeast "4.20" yes;

      # VirtualBox guest drivers in the kernel conflict with the ones in the
      # official additions package and prevent the vboxsf module from loading,
      # so disable them for now.
      VBOXGUEST = option no;
      DRM_VBOXVIDEO = option no;

      XEN                         = option yes;
      XEN_DOM0                    = option yes;
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
      XEN_SELFBALLOONING          = whenOlder "5.3" yes;

      # Enable device detection on virtio-mmio hypervisors
      VIRTIO_MMIO_CMDLINE_DEVICES = yes;
    };

    media = {
      MEDIA_DIGITAL_TV_SUPPORT = yes;
      MEDIA_CAMERA_SUPPORT     = yes;
      MEDIA_CONTROLLER         = yes;
      MEDIA_PCI_SUPPORT        = yes;
      MEDIA_USB_SUPPORT        = yes;
      MEDIA_ANALOG_TV_SUPPORT  = yes;
      VIDEO_STK1160_COMMON     = whenOlder "6.5" module;
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
      ZRAM                          = module;
      ZRAM_WRITEBACK                = option yes;
      ZRAM_MULTI_COMP               = whenAtLeast "6.2" yes;
      ZRAM_DEF_COMP_ZSTD            = whenAtLeast "5.11" yes;
      ZSWAP                         = option yes;
      ZSWAP_COMPRESSOR_DEFAULT_ZSTD = whenAtLeast "5.7" (mkOptionDefault yes);
      ZPOOL                         = yes;
      ZSMALLOC                      = option yes;
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
    } // {
      CRC32_SELFTEST           = option no;
      CRYPTO_TEST              = option no;
      EFI_TEST                 = option no;
      GLOB_SELFTEST            = option no;
      LOCK_TORTURE_TEST        = option no;
      MTD_TESTS                = option no;
      NOTIFIER_ERROR_INJECTION = option no;
      RCU_PERF_TEST            = whenOlder "5.9" no;
      RCU_SCALE_TEST           = whenAtLeast "5.10" no;
      TEST_ASYNC_DRIVER_PROBE  = option no;
      WW_MUTEX_SELFTEST        = option no;
      XZ_DEC_TEST              = option no;
    };

    criu = {
      # Unconditionally enabled, because it is required for CRIU and
      # it provides the kcmp() system call that Mesa depends on.
      CHECKPOINT_RESTORE  = yes;

      # Allows soft-dirty tracking on pages, used by CRIU.
      # See https://docs.kernel.org/admin-guide/mm/soft-dirty.html
      MEM_SOFT_DIRTY = mkIf (!stdenv.isx86_32) yes;
    };

    misc = let
      # Use zstd for kernel compression if 64-bit and newer than 5.9, otherwise xz.
      # i686 issues: https://github.com/NixOS/nixpkgs/pull/117961#issuecomment-812106375
      useZstd = stdenv.buildPlatform.is64bit && versionAtLeast version "5.9";
    in {
      # stdenv.hostPlatform.linux-kernel.target assumes uncompressed on RISC-V.
      KERNEL_UNCOMPRESSED  = mkIf stdenv.hostPlatform.isRiscV yes;
      KERNEL_XZ            = mkIf (!stdenv.hostPlatform.isRiscV && !useZstd) yes;
      KERNEL_ZSTD          = mkIf (!stdenv.hostPlatform.isRiscV && useZstd) yes;

      HID_BATTERY_STRENGTH = yes;
      # enabled by default in x86_64 but not arm64, so we do that here
      HIDRAW               = yes;

      # Enable loading HID fixups as eBPF from userspace
      HID_BPF            = whenAtLeast "6.3" yes;

      HID_ACRUX_FF       = yes;
      DRAGONRISE_FF      = yes;
      GREENASIA_FF       = yes;
      HOLTEK_FF          = yes;
      JOYSTICK_PSXPAD_SPI_FF = yes;
      LOGIG940_FF        = yes;
      NINTENDO_FF        = whenAtLeast "5.16" yes;
      PLAYSTATION_FF     = whenAtLeast "5.12" yes;
      SONY_FF            = yes;
      SMARTJOYPLUS_FF    = yes;
      THRUSTMASTER_FF    = yes;
      ZEROPLUS_FF        = yes;

      MODULE_COMPRESS      = whenOlder "5.13" yes;
      MODULE_COMPRESS_XZ   = yes;

      SYSVIPC            = yes;  # System-V IPC

      AIO                = yes;  # POSIX asynchronous I/O

      UNIX               = yes;  # Unix domain sockets.

      MD                 = yes;     # Device mapper (RAID, LVM, etc.)

      # Enable initrd support.
      BLK_DEV_INITRD    = yes;

      # Allows debugging systems that get stuck during suspend/resume
      PM_TRACE             = yes;
      PM_TRACE_RTC         = yes;

      ACCESSIBILITY        = yes; # Accessibility support
      AUXDISPLAY           = yes; # Auxiliary Display support
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

      BLK_DEV_INTEGRITY       = yes;
      BLK_DEV_ZONED           = yes;

      BLK_SED_OPAL = yes;

      # Enable support for block layer inline encryption
      BLK_INLINE_ENCRYPTION = whenAtLeast "5.8" yes;
      # ...but fall back to CPU encryption if unavailable
      BLK_INLINE_ENCRYPTION_FALLBACK = whenAtLeast "5.8" yes;

      BSD_PROCESS_ACCT_V3 = yes;

      SERIAL_DEV_BUS = yes; # enables support for serial devices
      SERIAL_DEV_CTRL_TTYPORT = yes; # enables support for TTY serial devices

      BT_HCIBTUSB_MTK = whenAtLeast "5.3" yes; # MediaTek protocol support
      BT_HCIUART_QCA = yes; # Qualcomm Atheros protocol support
      BT_HCIUART_SERDEV = yes; # required by BT_HCIUART_QCA
      BT_HCIUART = module; # required for BT devices with serial port interface (QCA6390)
      BT_HCIUART_BCSP = option yes;
      BT_HCIUART_H4   = option yes; # UART (H4) protocol support
      BT_HCIUART_LL   = option yes;
      BT_RFCOMM_TTY   = option yes; # RFCOMM TTY support
      BT_QCA = module; # enables QCA6390 bluetooth

      # Removed on 5.17 as it was unused
      # upstream: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0a4ee518185e902758191d968600399f3bc2be31
      CLEANCACHE = whenOlder "5.17" (option yes);

      FSCACHE_STATS = yes;

      DVB_DYNAMIC_MINORS = option yes; # we use udev

      EFI_STUB            = yes; # EFI bootloader in the bzImage itself
      EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER =
          whenOlder "6.2" (whenAtLeast "5.8" yes); # initrd kernel parameter for EFI
      CGROUPS             = yes; # used by systemd
      FHANDLE             = yes; # used by systemd
      SECCOMP             = yes; # used by systemd >= 231
      SECCOMP_FILTER      = yes; # ditto
      POSIX_MQUEUE        = yes;
      FRONTSWAP           = whenOlder "6.6" yes;
      FUSION              = yes; # Fusion MPT device support
      IDE                 = whenOlder "5.14" no; # deprecated IDE support, removed in 5.14
      IDLE_PAGE_TRACKING  = yes;

      JOYSTICK_IFORCE_232 = { optional = true; tristate = whenOlder "5.3" "y"; }; # I-Force Serial joysticks and wheels
      JOYSTICK_IFORCE_USB = { optional = true; tristate = whenOlder "5.3" "y"; }; # I-Force USB joysticks and wheels
      JOYSTICK_XPAD_FF    = option yes; # X-Box gamepad rumble support
      JOYSTICK_XPAD_LEDS  = option yes; # LED Support for Xbox360 controller 'BigX' LED

      KEYBOARD_APPLESPI = whenAtLeast "5.3" module;

      KEXEC_FILE      = option yes;
      KEXEC_JUMP      = option yes;

      PARTITION_ADVANCED    = yes; # Needed for LDM_PARTITION
      # Windows Logical Disk Manager (Dynamic Disk) support
      LDM_PARTITION         = yes;
      LOGIRUMBLEPAD2_FF     = yes; # Logitech Rumblepad 2 force feedback
      LOGO                  = no; # not needed
      MEDIA_ATTACH          = yes;
      MEGARAID_NEWGEN       = yes;

      MLX5_CORE_EN       = option yes;

      NVME_MULTIPATH = yes;

      NVME_AUTH = mkMerge [
        (whenBetween "6.0" "6.7" yes)
        (whenAtLeast "6.7" module)
      ];

      NVME_HOST_AUTH = whenAtLeast "6.7" yes;
      NVME_TCP_TLS = whenAtLeast "6.7" yes;

      NVME_TARGET = module;
      NVME_TARGET_PASSTHRU = whenAtLeast "5.9" yes;
      NVME_TARGET_AUTH = whenAtLeast "6.0" yes;
      NVME_TARGET_TCP_TLS = whenAtLeast "6.7" yes;

      PCI_P2PDMA = mkIf (stdenv.hostPlatform.is64bit && versionAtLeast version "4.20") yes;

      PSI = whenAtLeast "4.20" yes;

      MOUSE_ELAN_I2C_SMBUS = yes;
      MOUSE_PS2_ELANTECH = yes; # Elantech PS/2 protocol extension
      MOUSE_PS2_VMMOUSE  = yes;
      MTRR_SANITIZER     = yes;
      NET_FC             = yes; # Fibre Channel driver support
      # Needed for touchpads to work on some AMD laptops
      PINCTRL_AMD        = whenAtLeast "5.19" yes;
      # GPIO on Intel Bay Trail, for some Chromebook internal eMMC disks
      PINCTRL_BAYTRAIL   = yes;
      # GPIO for Braswell and Cherryview devices
      # Needs to be built-in to for integrated keyboards to function properly
      PINCTRL_CHERRYVIEW = yes;
      # 8 is default. Modern gpt tables on eMMC may go far beyond 8.
      MMC_BLOCK_MINORS   = freeform "32";

      REGULATOR  = yes; # Voltage and Current Regulator Support
      RC_DEVICES = option yes; # Enable IR devices
      RC_DECODERS = option yes; # Required for IR devices to work

      RT2800USB_RT53XX = yes;
      RT2800USB_RT55XX = yes;

      SCHED_AUTOGROUP  = yes;
      CFS_BANDWIDTH    = yes;

      SCSI_LOGGING = yes; # SCSI logging facility
      SERIAL_8250  = yes; # 8250/16550 and compatible serial support

      SLAB_FREELIST_HARDENED = yes;
      SLAB_FREELIST_RANDOM   = yes;

      SLIP_COMPRESSED = yes; # CSLIP compressed headers
      SLIP_SMART      = yes;

      HWMON         = yes;
      THERMAL_HWMON = yes; # Hardware monitoring support
      NVME_HWMON    = whenAtLeast "5.5" yes; # NVMe drives temperature reporting
      UEVENT_HELPER = no;

      USERFAULTFD   = yes;
      X86_CHECK_BIOS_CORRUPTION = yes;
      X86_MCE                   = yes;

      RAS = yes; # Needed for EDAC support

      # Our initrd init uses shebang scripts, so can't be modular.
      BINFMT_SCRIPT = yes;
      # For systemd-binfmt
      BINFMT_MISC   = option yes;

      # Disable the firmware helper fallback, udev doesn't implement it any more
      FW_LOADER_USER_HELPER_FALLBACK = option no;

      FW_LOADER_COMPRESS = whenAtLeast "5.3" yes;
      FW_LOADER_COMPRESS_ZSTD = whenAtLeast "5.19" yes;

      HOTPLUG_PCI_ACPI = yes; # PCI hotplug using ACPI
      HOTPLUG_PCI_PCIE = yes; # PCI-Expresscard hotplug support

      # Enable AMD's ROCm GPU compute stack
      HSA_AMD =     mkIf stdenv.hostPlatform.is64bit (whenAtLeast "4.20" yes);
      ZONE_DEVICE = mkIf stdenv.hostPlatform.is64bit (whenAtLeast "5.3" yes);
      HMM_MIRROR = whenAtLeast "5.3" yes;
      DRM_AMDGPU_USERPTR = whenAtLeast "5.3" yes;

      PREEMPT = no;
      PREEMPT_VOLUNTARY = yes;

      X86_AMD_PLATFORM_DEVICE = yes;
      X86_PLATFORM_DRIVERS_DELL = whenAtLeast "5.12" yes;
      X86_PLATFORM_DRIVERS_HP = whenAtLeast "6.1" yes;

      LIRC = yes;

      SCHED_CORE = whenAtLeast "5.14" yes;

      LRU_GEN = whenAtLeast "6.1"  yes;
      LRU_GEN_ENABLED =  whenAtLeast "6.1" yes;

      FSL_MC_UAPI_SUPPORT = mkIf (stdenv.hostPlatform.system == "aarch64-linux") (whenAtLeast "5.12" yes);

      ASHMEM =                 { optional = true; tristate = whenBetween "5.0" "5.18" "y";};
      ANDROID =                { optional = true; tristate = whenBetween "5.0" "5.19" "y";};
      ANDROID_BINDER_IPC =     { optional = true; tristate = whenAtLeast "5.0" "y";};
      ANDROID_BINDERFS =       { optional = true; tristate = whenAtLeast "5.0" "y";};
      ANDROID_BINDER_DEVICES = { optional = true; freeform = whenAtLeast "5.0" "binder,hwbinder,vndbinder";};

      TASKSTATS = yes;
      TASK_DELAY_ACCT = yes;
      TASK_XACCT = yes;
      TASK_IO_ACCOUNTING = yes;

      # Fresh toolchains frequently break -Werror build for minor issues.
      WERROR = whenAtLeast "5.15" no;

      # > CONFIG_KUNIT should not be enabled in a production environment. Enabling KUnit disables Kernel Address-Space Layout Randomization (KASLR), and tests may affect the state of the kernel in ways not suitable for production.
      # https://www.kernel.org/doc/html/latest/dev-tools/kunit/start.html
      KUNIT = whenAtLeast "5.5" no;

      # Set system time from RTC on startup and resume
      RTC_HCTOSYS = option yes;

      # Expose watchdog information in sysfs
      WATCHDOG_SYSFS = yes;

      # Enable generic kernel watch queues
      # See https://docs.kernel.org/core-api/watch_queue.html
      WATCH_QUEUE = whenAtLeast "5.8" yes;
    } // optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "aarch64-linux") {
      # Enable CPU/memory hotplug support
      # Allows you to dynamically add & remove CPUs/memory to a VM client running NixOS without requiring a reboot
      ACPI_HOTPLUG_CPU = yes;
      ACPI_HOTPLUG_MEMORY = yes;
      MEMORY_HOTPLUG = yes;
      MEMORY_HOTREMOVE = yes;
      HOTPLUG_CPU = yes;
      MIGRATION = yes;
      SPARSEMEM = yes;

      # Bump the maximum number of CPUs to support systems like EC2 x1.*
      # instances and Xeon Phi.
      NR_CPUS = freeform "384";

      # Enable LEDS to display link-state status of PHY devices (i.e. eth lan/wan interfaces)
      LED_TRIGGER_PHY = whenAtLeast "4.10" yes;
    } // optionalAttrs (stdenv.hostPlatform.system == "armv7l-linux" || stdenv.hostPlatform.system == "aarch64-linux") {
      # Enables support for the Allwinner Display Engine 2.0
      SUN8I_DE2_CCU = yes;

      # See comments on https://github.com/NixOS/nixpkgs/commit/9b67ea9106102d882f53d62890468071900b9647
      CRYPTO_AEGIS128_SIMD = whenAtLeast "5.4" no;

      # Distros should configure the default as a kernel option.
      # We previously defined it on the kernel command line as cma=
      # The kernel command line will override a platform-specific configuration from its device tree.
      # https://github.com/torvalds/linux/blob/856deb866d16e29bd65952e0289066f6078af773/kernel/dma/contiguous.c#L35-L44
      CMA_SIZE_MBYTES = freeform "32";

      # Add debug interfaces for CMA
      CMA_DEBUGFS = yes;
      CMA_SYSFS = yes;

      # https://docs.kernel.org/arch/arm/mem_alignment.html
      # tldr:
      #  when buggy userspace code emits illegal misaligned LDM, STM,
      #  LDRD and STRDs, the instructions trap, are caught, and then
      #  are emulated by the kernel.
      #
      #  This is the default on armv7l, anyway, but it is explicitly
      #  enabled here for the sake of providing context for the
      #  aarch64 compat option which follows.
      ALIGNMENT_TRAP = mkIf (stdenv.hostPlatform.system == "armv7l-linux") yes;

      # https://patchwork.kernel.org/project/linux-arm-kernel/patch/20220701135322.3025321-1-ardb@kernel.org/
      # tldr:
      #  when encountering alignment faults under aarch64, this option
      #  makes the kernel attempt to handle the fault by doing the
      #  same style of misaligned emulation that is performed under
      #  armv7l (see above option).
      #
      #  This minimizes the potential for aarch32 userspace to behave
      #  differently when run under aarch64 kernels compared to when
      #  it is run under an aarch32 kernel.
      COMPAT_ALIGNMENT_FIXUPS = mkIf (stdenv.hostPlatform.system == "aarch64-linux") (whenAtLeast "6.1" yes);
    } // optionalAttrs (versionAtLeast version "5.4" && (stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "aarch64-linux")) {
      # Required for various hardware features on Chrome OS devices
      CHROME_PLATFORMS = yes;
      CHROMEOS_TBMC = module;

      CROS_EC = module;

      CROS_EC_I2C = module;
      CROS_EC_SPI = module;
      CROS_EC_LPC = module;
      CROS_EC_ISHTP = module;

      CROS_KBD_LED_BACKLIGHT = module;

      TCG_TIS_SPI_CR50 = whenAtLeast "5.5" yes;
    } // optionalAttrs (versionAtLeast version "5.4" && stdenv.hostPlatform.system == "x86_64-linux") {
      CHROMEOS_LAPTOP = module;
      CHROMEOS_PSTORE = module;
    } // optionalAttrs (stdenv.hostPlatform.system == "x86_64-linux") {
      # Enable x86 resource control
      X86_CPU_RESCTRL = whenAtLeast "5.0" yes;

      # Enable TSX on CPUs where it's not vulnerable
      X86_INTEL_TSX_MODE_AUTO = yes;

      # Enable AMD Wi-Fi RF band mitigations
      # See https://cateee.net/lkddb/web-lkddb/AMD_WBRF.html
      AMD_WBRF = whenAtLeast "6.8" yes;

      # Enable Intel Turbo Boost Max 3.0
      INTEL_TURBO_MAX_3 = yes;
    };

    accel = {
      # Build DRM accelerator devices
      DRM_ACCEL = whenAtLeast "6.2" yes;
    };
  };
in
  flattenKConf options
