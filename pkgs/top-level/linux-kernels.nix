{ pkgs
, linuxKernel
, config
, buildPackages
, callPackage
, makeOverridable
, recurseIntoAttrs
, dontRecurseIntoAttrs
, stdenv
, stdenvNoCC
, newScope
, lib
, fetchurl
, gcc10Stdenv
}:

# When adding a kernel:
  # - Update packageAliases.linux_latest to the latest version
  # - Update the rev in ../os-specific/linux/kernel/linux-libre.nix to the latest one.
  # - Update linux_latest_hardened when the patches become available

with linuxKernel;

let
  deblobKernel = kernel: callPackage ../os-specific/linux/kernel/linux-libre.nix {
    linux = kernel;
  };

  markBroken = drv: drv.overrideAttrs ({ meta ? {}, ... }: {
    meta = meta // { broken = true; };
  });

  # Hardened Linux
  hardenedKernelFor = kernel': overrides:
    let
      kernel = kernel'.override overrides;
      version = kernelPatches.hardened.${kernel.meta.branch}.version;
      major = lib.versions.major version;
      sha256 = kernelPatches.hardened.${kernel.meta.branch}.sha256;
      modDirVersion' = builtins.replaceStrings [ kernel.version ] [ version ] kernel.modDirVersion;
    in kernel.override {
      structuredExtraConfig = import ../os-specific/linux/kernel/hardened/config.nix {
        inherit stdenv lib version;
      };
      argsOverride = {
        inherit version;
        pname = "linux-hardened";
        modDirVersion = modDirVersion' + kernelPatches.hardened.${kernel.meta.branch}.extra;
        src = fetchurl {
          url = "mirror://kernel/linux/kernel/v${major}.x/linux-${version}.tar.xz";
          inherit sha256;
        };
        extraMeta = {
          broken = kernel.meta.broken;
        };
      };
      kernelPatches = kernel.kernelPatches ++ [
        kernelPatches.hardened.${kernel.meta.branch}
      ];
      isHardened = true;
  };
in {
  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  kernels = recurseIntoAttrs (lib.makeExtensible (self: with self;
    let callPackage = newScope self; in {

    # NOTE: PLEASE DO NOT ADD NEW DOWNSTREAM KERNELS TO NIXPKGS.
    # New vendor kernels should go to nixos-hardware instead.
    # e.g. https://github.com/NixOS/nixos-hardware/tree/master/microsoft/surface/kernel

    linux_rpi1 = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
      kernelPatches = with kernelPatches; [
        bridge_stp_helper
        request_key_helper
      ];
      rpiVersion = 1;
    };

    linux_rpi2 = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
      kernelPatches = with kernelPatches; [
        bridge_stp_helper
        request_key_helper
      ];
      rpiVersion = 2;
    };

    linux_rpi3 = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
      kernelPatches = with kernelPatches; [
        bridge_stp_helper
        request_key_helper
      ];
      rpiVersion = 3;
    };

    linux_rpi4 = callPackage ../os-specific/linux/kernel/linux-rpi.nix {
      kernelPatches = with kernelPatches; [
        bridge_stp_helper
        request_key_helper
      ];
      rpiVersion = 4;
    };

    linux_5_4 = callPackage ../os-specific/linux/kernel/mainline.nix {
      branch = "5.4";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.rtl8761b_support
      ];
    };

    linux_rt_5_4 = callPackage ../os-specific/linux/kernel/linux-rt-5.4.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_5_10 = callPackage ../os-specific/linux/kernel/mainline.nix {
      branch = "5.10";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_rt_5_10 = callPackage ../os-specific/linux/kernel/linux-rt-5.10.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.export-rt-sched-migrate
      ];
    };

    linux_5_15 = callPackage ../os-specific/linux/kernel/mainline.nix {
      branch = "5.15";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_rt_5_15 = callPackage ../os-specific/linux/kernel/linux-rt-5.15.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.export-rt-sched-migrate
      ];
    };

    linux_6_1 = callPackage ../os-specific/linux/kernel/mainline.nix {
      branch = "6.1";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_rt_6_1 = callPackage ../os-specific/linux/kernel/linux-rt-6.1.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.export-rt-sched-migrate
      ];
    };

    linux_6_6 = callPackage ../os-specific/linux/kernel/mainline.nix {
      branch = "6.6";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_rt_6_6 = callPackage ../os-specific/linux/kernel/linux-rt-6.6.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.export-rt-sched-migrate
      ];
    };

    linux_6_10 = callPackage ../os-specific/linux/kernel/mainline.nix {
      branch = "6.10";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_6_11 = callPackage ../os-specific/linux/kernel/mainline.nix {
      branch = "6.11";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_testing = let
      testing = callPackage ../os-specific/linux/kernel/mainline.nix {
        # A special branch that tracks the kernel under the release process
        # i.e. which has at least a public rc1 and is not released yet.
        branch = "testing";
        kernelPatches = [
          kernelPatches.bridge_stp_helper
          kernelPatches.request_key_helper
        ];
      };
      latest = packageAliases.linux_latest.kernel;
    in if latest.kernelAtLeast testing.baseVersion
       then latest
       else testing;

    # Using zenKernels like this due lqx&zen came from one source, but may have different base kernel version
    # https://github.com/NixOS/nixpkgs/pull/161773#discussion_r820134708
    zenKernels = callPackage ../os-specific/linux/kernel/zen-kernels.nix;

    linux_zen = zenKernels {
      variant = "zen";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_lqx = zenKernels {
      variant = "lqx";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    # This contains the variants of the XanMod kernel
    xanmodKernels = callPackage ../os-specific/linux/kernel/xanmod-kernels.nix;

    linux_xanmod = xanmodKernels {
      variant = "lts";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };
    linux_xanmod_stable = xanmodKernels {
      variant = "main";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };
    linux_xanmod_latest = xanmodKernels {
      variant = "main";
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_libre = deblobKernel packageAliases.linux_default.kernel;

    linux_latest_libre = deblobKernel packageAliases.linux_latest.kernel;

    linux_hardened = hardenedKernelFor packageAliases.linux_default.kernel { };

    linux_5_4_hardened = markBroken (hardenedKernelFor kernels.linux_5_4 {
      stdenv = gcc10Stdenv;
      buildPackages = buildPackages // { stdenv = buildPackages.gcc10Stdenv; };
    });
    linux_5_10_hardened = hardenedKernelFor kernels.linux_5_10 { };
    linux_5_15_hardened = hardenedKernelFor kernels.linux_5_15 { };
    linux_6_1_hardened = hardenedKernelFor kernels.linux_6_1 { };
    linux_6_6_hardened = hardenedKernelFor kernels.linux_6_6 { };

  } // lib.optionalAttrs config.allowAliases {
    linux_4_14 = throw "linux 4.14 was removed because it will reach its end of life within 23.11";
    linux_4_19 = throw "linux 4.19 was removed because it will reach its end of life within 24.11";
    linux_6_4 = throw "linux 6.4 was removed because it has reached its end of life upstream";
    linux_6_5 = throw "linux 6.5 was removed because it has reached its end of life upstream";
    linux_6_7 = throw "linux 6.7 was removed because it has reached its end of life upstream";
    linux_6_8 = throw "linux 6.8 was removed because it has reached its end of life upstream";
    linux_6_9 = throw "linux 6.9 was removed because it has reached its end of life upstream";

    linux_xanmod_tt = throw "linux_xanmod_tt was removed because upstream no longer offers this option";

    linux_4_14_hardened = throw "linux 4.14 was removed because it will reach its end of life within 23.11";
    linux_4_19_hardened = throw "linux 4.19 was removed because it will reach its end of life within 24.11";
    linux_6_4_hardened = throw "linux 6.4 was removed because it has reached its end of life upstream";
    linux_6_5_hardened = throw "linux 6.5 was removed because it has reached its end of life upstream";
    linux_6_7_hardened = throw "linux 6.7 was removed because it has reached its end of life upstream";
    linux_6_8_hardened = throw "linux 6.8 was removed because it has reached its end of life upstream";
    linux_6_9_hardened = throw "linux 6.9 was removed because it has reached its end of life upstream";
  }));
  /*  Linux kernel modules are inherently tied to a specific kernel.  So
    rather than provide specific instances of those packages for a
    specific kernel, we have a function that builds those packages
    for a specific kernel.  This function can then be called for
    whatever kernel you're using. */

  packagesFor = kernel_: lib.makeExtensible (self: with self;
    let callPackage = newScope self; in {
    inherit callPackage;
    kernel = kernel_;
    inherit (kernel) stdenv; # in particular, use the same compiler by default

    # to help determine module compatibility
    inherit (kernel) isZen isHardened isLibre;
    inherit (kernel) kernelOlder kernelAtLeast;
    # Obsolete aliases (these packages do not depend on the kernel).
    inherit (pkgs) odp-dpdk pktgen; # added 2018-05
    inherit (pkgs) bcc bpftrace; # added 2021-12
    inherit (pkgs) oci-seccomp-bpf-hook; # added 2022-11
    inherit (pkgs) dpdk; # added 2024-03

    acpi_call = callPackage ../os-specific/linux/acpi-call {};

    akvcam = callPackage ../os-specific/linux/akvcam { };

    apfs = callPackage ../os-specific/linux/apfs { };

    ax99100 = callPackage ../os-specific/linux/ax99100 {};

    batman_adv = callPackage ../os-specific/linux/batman-adv {};

    bbswitch = callPackage ../os-specific/linux/bbswitch {};

    ch9344 = callPackage ../os-specific/linux/ch9344 { };

    chipsec = callPackage ../tools/security/chipsec {
      inherit kernel;
      withDriver = true;
    };

    cryptodev = callPackage ../os-specific/linux/cryptodev { };

    cpupower = callPackage ../os-specific/linux/cpupower { };

    deepin-anything-module = callPackage ../os-specific/linux/deepin-anything-module { };

    ddcci-driver = callPackage ../os-specific/linux/ddcci { };

    dddvb = callPackage ../os-specific/linux/dddvb { };

    decklink = callPackage ../os-specific/linux/decklink { };

    digimend = callPackage ../os-specific/linux/digimend { };

    dpdk-kmods = callPackage ../os-specific/linux/dpdk-kmods { };

    exfat-nofuse = if lib.versionOlder kernel.version "5.8" then callPackage ../os-specific/linux/exfat { } else null;

    evdi = callPackage ../os-specific/linux/evdi { };

    fanout = callPackage ../os-specific/linux/fanout { };

    framework-laptop-kmod = callPackage ../os-specific/linux/framework-laptop-kmod { };

    fwts-efi-runtime = callPackage ../os-specific/linux/fwts/module.nix { };

    gasket = callPackage ../os-specific/linux/gasket { };

    gcadapter-oc-kmod = callPackage ../os-specific/linux/gcadapter-oc-kmod { };

    hyperv-daemons = callPackage ../os-specific/linux/hyperv-daemons { };

    e1000e = if lib.versionOlder kernel.version "4.10" then  callPackage ../os-specific/linux/e1000e {} else null;

    intel-speed-select = if lib.versionAtLeast kernel.version "5.3" then callPackage ../os-specific/linux/intel-speed-select { } else null;

    ipu6-drivers =
      if kernelOlder "6.10"
      then callPackage ../os-specific/linux/ipu6-drivers {}
      else null;

    ivsc-driver = callPackage ../os-specific/linux/ivsc-driver {};

    ixgbevf = callPackage ../os-specific/linux/ixgbevf {};

    it87 = callPackage ../os-specific/linux/it87 {};

    asus-ec-sensors = callPackage ../os-specific/linux/asus-ec-sensors {};

    asus-wmi-sensors = callPackage ../os-specific/linux/asus-wmi-sensors {};

    ena = callPackage ../os-specific/linux/ena {};

    lenovo-legion-module = callPackage ../os-specific/linux/lenovo-legion { };

    linux-gpib = callPackage ../applications/science/electronics/linux-gpib/kernel.nix { };

    liquidtux = callPackage ../os-specific/linux/liquidtux {};

    lkrg = callPackage ../os-specific/linux/lkrg {};

    v4l2loopback = callPackage ../os-specific/linux/v4l2loopback { };

    lttng-modules = callPackage ../os-specific/linux/lttng-modules { };

    mstflint_access = callPackage ../os-specific/linux/mstflint_access { };

    broadcom_sta = callPackage ../os-specific/linux/broadcom-sta { };

    tbs = callPackage ../os-specific/linux/tbs { };

    mbp2018-bridge-drv = callPackage ../os-specific/linux/mbp-modules/mbp2018-bridge-drv { };

    nct6687d = callPackage ../os-specific/linux/nct6687d { };

    new-lg4ff = callPackage ../os-specific/linux/new-lg4ff { };

    nvidiabl = callPackage ../os-specific/linux/nvidiabl { };

    nvidiaPackages = dontRecurseIntoAttrs (lib.makeExtensible (_: callPackage ../os-specific/linux/nvidia-x11 { }));

    nvidia_x11             = nvidiaPackages.stable;
    nvidia_x11_beta        = nvidiaPackages.beta;
    nvidia_x11_legacy340   = nvidiaPackages.legacy_340;
    nvidia_x11_legacy390   = nvidiaPackages.legacy_390;
    nvidia_x11_legacy470   = nvidiaPackages.legacy_470;
    nvidia_x11_legacy535   = nvidiaPackages.legacy_535;
    nvidia_x11_production  = nvidiaPackages.production;
    nvidia_x11_vulkan_beta = nvidiaPackages.vulkan_beta;
    nvidia_dc              = nvidiaPackages.dc;
    nvidia_dc_520          = nvidiaPackages.dc_520;
    nvidia_dc_535          = nvidiaPackages.dc_535;

    # this is not a replacement for nvidia_x11*
    # only the opensource kernel driver exposed for hydra to build
    nvidia_x11_beta_open         = nvidiaPackages.beta.open;
    nvidia_x11_production_open   = nvidiaPackages.production.open;
    nvidia_x11_stable_open       = nvidiaPackages.stable.open;
    nvidia_x11_vulkan_beta_open  = nvidiaPackages.vulkan_beta.open;

    openrazer = callPackage ../os-specific/linux/openrazer/driver.nix { };

    ply = callPackage ../os-specific/linux/ply { };

    r8125 = callPackage ../os-specific/linux/r8125 { };

    r8168 = callPackage ../os-specific/linux/r8168 { };

    rtl8188eus-aircrack = callPackage ../os-specific/linux/rtl8188eus-aircrack { };

    rtl8192eu = callPackage ../os-specific/linux/rtl8192eu { };

    rtl8189es = callPackage ../os-specific/linux/rtl8189es { };

    rtl8189fs = callPackage ../os-specific/linux/rtl8189fs { };

    rtl8723ds = callPackage ../os-specific/linux/rtl8723ds { };

    rtl8812au = callPackage ../os-specific/linux/rtl8812au { };

    rtl8814au = callPackage ../os-specific/linux/rtl8814au { };

    rtl8852au = callPackage ../os-specific/linux/rtl8852au { };

    rtl8852bu = callPackage ../os-specific/linux/rtl8852bu { };

    rtl88xxau-aircrack = callPackage ../os-specific/linux/rtl88xxau-aircrack {};

    rtl8821au = callPackage ../os-specific/linux/rtl8821au { };

    rtl8821ce = callPackage ../os-specific/linux/rtl8821ce { };

    rtl88x2bu = callPackage ../os-specific/linux/rtl88x2bu { };

    rtl8821cu = callPackage ../os-specific/linux/rtl8821cu { };

    rtw88 = callPackage ../os-specific/linux/rtw88 { };

    rtw89 = if lib.versionOlder kernel.version "5.16" then callPackage ../os-specific/linux/rtw89 { } else null;

    openafs_1_8 = callPackage ../servers/openafs/1.8/module.nix { };
    # Current stable release; don't backport release updates!
    openafs = openafs_1_8;

    opensnitch-ebpf = if lib.versionAtLeast kernel.version "5.10" then callPackage ../os-specific/linux/opensnitch-ebpf { } else null;

    facetimehd = callPackage ../os-specific/linux/facetimehd { };

    rust-out-of-tree-module = if lib.versionAtLeast kernel.version "6.7" then callPackage ../os-specific/linux/rust-out-of-tree-module { } else null;

    tuxedo-keyboard = if lib.versionAtLeast kernel.version "4.14" then callPackage ../os-specific/linux/tuxedo-keyboard { } else null;

    jool = callPackage ../os-specific/linux/jool { };

    kvmfr = callPackage ../os-specific/linux/kvmfr { };

    mba6x_bl = callPackage ../os-specific/linux/mba6x_bl { };

    mwprocapture = callPackage ../os-specific/linux/mwprocapture { };

    mxu11x0 = callPackage ../os-specific/linux/mxu11x0 { };

    # compiles but has to be integrated into the kernel somehow
    # Let's have it uncommented and finish it..
    ndiswrapper = callPackage ../os-specific/linux/ndiswrapper { };

    netatop = callPackage ../os-specific/linux/netatop { };

    perf = callPackage ../os-specific/linux/kernel/perf { };

    phc-intel = if lib.versionAtLeast kernel.version "4.10" then callPackage ../os-specific/linux/phc-intel { } else null;

    prl-tools = callPackage ../os-specific/linux/prl-tools { };

    isgx = callPackage ../os-specific/linux/isgx { };

    rr-zen_workaround = callPackage ../development/tools/analysis/rr/zen_workaround.nix { };

    shufflecake = callPackage ../os-specific/linux/shufflecake {};

    sysdig = callPackage ../os-specific/linux/sysdig {};

    systemtap = callPackage ../development/tools/profiling/systemtap { };

    system76 = callPackage ../os-specific/linux/system76 { };

    system76-acpi = callPackage ../os-specific/linux/system76-acpi { };

    system76-power = callPackage ../os-specific/linux/system76-power { };

    system76-io = callPackage ../os-specific/linux/system76-io { };

    system76-scheduler = callPackage ../os-specific/linux/system76-scheduler { };

    tmon = callPackage ../os-specific/linux/tmon { };

    tp_smapi = callPackage ../os-specific/linux/tp_smapi { };

    turbostat = callPackage ../os-specific/linux/turbostat { };

    trelay = callPackage ../os-specific/linux/trelay { };

    universal-pidff = callPackage ../os-specific/linux/universal-pidff { };

    usbip = callPackage ../os-specific/linux/usbip { };

    v86d = callPackage ../os-specific/linux/v86d { };

    veikk-linux-driver = callPackage ../os-specific/linux/veikk-linux-driver { };
    vendor-reset = callPackage ../os-specific/linux/vendor-reset { };

    vhba = callPackage ../applications/emulators/cdemu/vhba.nix { };

    virtio_vmmci  = callPackage ../os-specific/linux/virtio_vmmci { };

    virtualbox = callPackage ../os-specific/linux/virtualbox {
      virtualbox = pkgs.virtualboxHardened;
    };

    virtualboxGuestAdditions = callPackage ../applications/virtualization/virtualbox/guest-additions { };

    mm-tools = callPackage ../os-specific/linux/mm-tools { };

    vmm_clock = callPackage ../os-specific/linux/vmm_clock { };

    vmware = callPackage ../os-specific/linux/vmware { };

    wireguard = if lib.versionOlder kernel.version "5.6" then callPackage ../os-specific/linux/wireguard { } else null;

    x86_energy_perf_policy = callPackage ../os-specific/linux/x86_energy_perf_policy { };

    xone = if lib.versionAtLeast kernel.version "5.4" then callPackage ../os-specific/linux/xone { } else null;

    xpadneo = callPackage ../os-specific/linux/xpadneo { };

    ithc = callPackage ../os-specific/linux/ithc { };

    ryzen-smu = callPackage ../os-specific/linux/ryzen-smu { };

    zenpower = callPackage ../os-specific/linux/zenpower { };

    zfs_2_1 = callPackage ../os-specific/linux/zfs/2_1.nix {
      configFile = "kernel";
      inherit pkgs kernel;
    };
    zfs_2_2 = callPackage ../os-specific/linux/zfs/2_2.nix {
      configFile = "kernel";
      inherit pkgs kernel;
    };
    zfs_unstable = callPackage ../os-specific/linux/zfs/unstable.nix {
      configFile = "kernel";
      inherit pkgs kernel;
    };
    zfs = zfs_2_2;

    can-isotp = callPackage ../os-specific/linux/can-isotp { };

    qc71_laptop = callPackage ../os-specific/linux/qc71_laptop { };

    hid-ite8291r3 = callPackage ../os-specific/linux/hid-ite8291r3 { };

    hid-t150 = callPackage ../os-specific/linux/hid-t150 { };

    hid-tmff2 = callPackage ../os-specific/linux/hid-tmff2 { };

    hpuefi-mod = callPackage ../os-specific/linux/hpuefi-mod { };

    drbd = callPackage ../os-specific/linux/drbd/driver.nix { };

    nullfs = callPackage ../os-specific/linux/nullfs { };

  } // lib.optionalAttrs config.allowAliases {
    ati_drivers_x11 = throw "ati drivers are no longer supported by any kernel >=4.1"; # added 2021-05-18;
    hid-nintendo = throw "hid-nintendo was added in mainline kernel version 5.16"; # Added 2023-07-30
    sch_cake = throw "sch_cake was added in mainline kernel version 4.19"; # Added 2023-06-14
    rtl8723bs = throw "rtl8723bs was added in mainline kernel version 4.12"; # Added 2023-06-14
    vm-tools = self.mm-tools;
    xmm7360-pci = throw "Support for the XMM7360 WWAN card was added to the iosm kmod in mainline kernel version 5.18";
    amdgpu-pro = throw "amdgpu-pro was removed due to lack of maintenance"; # Added 2024-06-16
    kvdo = throw "kvdo was removed, because it was added to mainline in kernel version 6.9"; # Added 2024-07-08
  });

  hardenedPackagesFor = kernel: overrides: packagesFor (hardenedKernelFor kernel overrides);

  vanillaPackages = {
    # recurse to build modules for the kernels
    linux_5_4 = recurseIntoAttrs (packagesFor kernels.linux_5_4);
    linux_5_10 = recurseIntoAttrs (packagesFor kernels.linux_5_10);
    linux_5_15 = recurseIntoAttrs (packagesFor kernels.linux_5_15);
    linux_6_1 = recurseIntoAttrs (packagesFor kernels.linux_6_1);
    linux_6_6 = recurseIntoAttrs (packagesFor kernels.linux_6_6);
    linux_6_10 = recurseIntoAttrs (packagesFor kernels.linux_6_10);
    linux_6_11 = recurseIntoAttrs (packagesFor kernels.linux_6_11);
  } // lib.optionalAttrs config.allowAliases {
    linux_4_14 = throw "linux 4.14 was removed because it will reach its end of life within 23.11"; # Added 2023-10-11
    linux_4_19 = throw "linux 4.19 was removed because it will reach its end of life within 24.11"; # Added 2024-09-21
    linux_6_4 = throw "linux 6.4 was removed because it reached its end of life upstream"; # Added 2023-10-02
    linux_6_5 = throw "linux 6.5 was removed because it reached its end of life upstream"; # Added 2024-02-28
    linux_6_7 = throw "linux 6.7 was removed because it reached its end of life upstream"; # Added 2024-04-04
    linux_6_8 = throw "linux 6.8 was removed because it reached its end of life upstream"; # Added 2024-08-02
    linux_6_9 = throw "linux 6.9 was removed because it reached its end of life upstream"; # Added 2024-08-02
  };

  rtPackages = {
     # realtime kernel packages
     linux_rt_5_4 = packagesFor kernels.linux_rt_5_4;
     linux_rt_5_10 = packagesFor kernels.linux_rt_5_10;
     linux_rt_5_15 = packagesFor kernels.linux_rt_5_15;
     linux_rt_6_1 = packagesFor kernels.linux_rt_6_1;
     linux_rt_6_6 = packagesFor kernels.linux_rt_6_6;
  };

  rpiPackages = {
    linux_rpi1 = packagesFor kernels.linux_rpi1;
    linux_rpi2 = packagesFor kernels.linux_rpi2;
    linux_rpi3 = packagesFor kernels.linux_rpi3;
    linux_rpi4 = packagesFor kernels.linux_rpi4;
  };

  packages = recurseIntoAttrs (vanillaPackages // rtPackages // rpiPackages // {

    # Intentionally lacks recurseIntoAttrs, as -rc kernels will quite likely break out-of-tree modules and cause failed Hydra builds.
    linux_testing = packagesFor kernels.linux_testing;

    linux_hardened = recurseIntoAttrs (packagesFor kernels.linux_hardened);

    linux_5_4_hardened = recurseIntoAttrs (packagesFor kernels.linux_5_4_hardened);
    linux_5_10_hardened = recurseIntoAttrs (packagesFor kernels.linux_5_10_hardened);
    linux_5_15_hardened = recurseIntoAttrs (packagesFor kernels.linux_5_15_hardened);
    linux_6_1_hardened = recurseIntoAttrs (packagesFor kernels.linux_6_1_hardened);
    linux_6_6_hardened = recurseIntoAttrs (packagesFor kernels.linux_6_6_hardened);

    linux_zen = recurseIntoAttrs (packagesFor kernels.linux_zen);
    linux_lqx = recurseIntoAttrs (packagesFor kernels.linux_lqx);
    linux_xanmod = recurseIntoAttrs (packagesFor kernels.linux_xanmod);
    linux_xanmod_stable = recurseIntoAttrs (packagesFor kernels.linux_xanmod_stable);
    linux_xanmod_latest = recurseIntoAttrs (packagesFor kernels.linux_xanmod_latest);

    linux_libre = recurseIntoAttrs (packagesFor kernels.linux_libre);

    linux_latest_libre = recurseIntoAttrs (packagesFor kernels.linux_latest_libre);
    __recurseIntoDerivationForReleaseJobs = true;
  } // lib.optionalAttrs config.allowAliases {
    linux_4_14_hardened = throw "linux 4.14 was removed because it will reach its end of life within 23.11";
    linux_4_19_hardened = throw "linux 4.19 was removed because it will reach its end of life within 24.11";
    linux_6_4_hardened = throw "linux 6.4 was removed because it has reached its end of life upstream";
    linux_6_5_hardened = throw "linux 6.5 was removed because it has reached its end of life upstream";
    linux_6_7_hardened = throw "linux 6.7 was removed because it has reached its end of life upstream";
    linux_6_8_hardened = throw "linux 6.8 was removed because it has reached its end of life upstream";
    linux_6_9_hardened = throw "linux 6.9 was removed because it has reached its end of life upstream";
    linux_xanmod_tt = throw "linux_xanmod_tt was removed because upstream no longer offers this option";
  });

  packageAliases = {
    linux_default = packages.linux_6_6;
    # Update this when adding the newest kernel major version!
    linux_latest = packages.linux_6_11;
    linux_mptcp = throw "'linux_mptcp' has been moved to https://github.com/teto/mptcp-flake";
    linux_rt_default = packages.linux_rt_5_15;
    linux_rt_latest = packages.linux_rt_6_6;
  };

  manualConfig = callPackage ../os-specific/linux/kernel/manual-config.nix {};

  customPackage = { version, src, modDirVersion ? lib.versions.pad 3 version, configfile, allowImportFromDerivation ? true }:
    recurseIntoAttrs (packagesFor (manualConfig {
      inherit version src modDirVersion configfile allowImportFromDerivation;
    }));

  # Derive one of the default .config files
  linuxConfig = {
    src,
    kernelPatches ? [],
    version ? (builtins.parseDrvName src.name).version,
    makeTarget ? "defconfig",
    name ? "kernel.config",
  }: stdenvNoCC.mkDerivation {
    inherit name src;
    depsBuildBuild = [ buildPackages.stdenv.cc ]
      ++ lib.optionals (lib.versionAtLeast version "4.16") [ buildPackages.bison buildPackages.flex ];
    patches = map (p: p.patch) kernelPatches;  # Patches may include new configs.
    postPatch = ''
      patchShebangs scripts/
    '';
    buildPhase = ''
      set -x
      make \
        ARCH=${stdenv.hostPlatform.linuxArch} \
        HOSTCC=${buildPackages.stdenv.cc.targetPrefix}gcc \
        ${makeTarget}
    '';
    installPhase = ''
      cp .config $out
    '';
  };

  buildLinux = callPackage ../os-specific/linux/kernel/generic.nix {};
}
