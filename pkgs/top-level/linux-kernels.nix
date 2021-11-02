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
        inherit lib version;
      };
      argsOverride = {
        inherit version;
        src = fetchurl {
          url = "mirror://kernel/linux/kernel/v${major}.x/linux-${version}.tar.xz";
          inherit sha256;
        };
      };
      kernelPatches = kernel.kernelPatches ++ [
        kernelPatches.hardened.${kernel.meta.branch}
      ];
      modDirVersionArg = modDirVersion' + (kernelPatches.hardened.${kernel.meta.branch}).extra;
      isHardened = true;
  };
in {
  kernelPatches = callPackage ../os-specific/linux/kernel/patches.nix { };

  kernels = recurseIntoAttrs (lib.makeExtensible (self: with self;
    let callPackage = newScope self; in {

    linux_mptcp_95 = callPackage ../os-specific/linux/kernel/linux-mptcp-95.nix {
      kernelPatches = linux_4_19.kernelPatches;
    };

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

    linux_4_4 = callPackage ../os-specific/linux/kernel/linux-4.4.nix {
      kernelPatches =
        [ kernelPatches.bridge_stp_helper
          kernelPatches.request_key_helper_updated
          kernelPatches.cpu-cgroup-v2."4.4"
          kernelPatches.modinst_arg_list_too_long
        ];
    };

    linux_4_9 = callPackage ../os-specific/linux/kernel/linux-4.9.nix {
      kernelPatches =
        [ kernelPatches.bridge_stp_helper
          kernelPatches.request_key_helper_updated
          kernelPatches.cpu-cgroup-v2."4.9"
          kernelPatches.modinst_arg_list_too_long
        ];
    };

    linux_4_14 = callPackage ../os-specific/linux/kernel/linux-4.14.nix {
      kernelPatches =
        [ kernelPatches.bridge_stp_helper
          kernelPatches.request_key_helper
          # See pkgs/os-specific/linux/kernel/cpu-cgroup-v2-patches/README.md
          # when adding a new linux version
          kernelPatches.cpu-cgroup-v2."4.11"
          kernelPatches.modinst_arg_list_too_long
        ];
    };

    linux_4_19 = callPackage ../os-specific/linux/kernel/linux-4.19.nix {
      kernelPatches =
        [ kernelPatches.bridge_stp_helper
          kernelPatches.request_key_helper
          kernelPatches.modinst_arg_list_too_long
        ];
    };

    linux_5_4 = callPackage ../os-specific/linux/kernel/linux-5.4.nix {
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

    linux_5_10 = callPackage ../os-specific/linux/kernel/linux-5.10.nix {
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

    linux_rt_5_11 = callPackage ../os-specific/linux/kernel/linux-rt-5.11.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.export-rt-sched-migrate
      ];
    };

    linux_5_14 = callPackage ../os-specific/linux/kernel/linux-5.14.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_5_15 = callPackage ../os-specific/linux/kernel/linux-5.15.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_testing = callPackage ../os-specific/linux/kernel/linux-testing.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_testing_bcachefs = callPackage ../os-specific/linux/kernel/linux-testing-bcachefs.nix rec {
      kernel = linux_5_14;
      kernelPatches = kernel.kernelPatches;
   };

    linux_hardkernel_4_14 = callPackage ../os-specific/linux/kernel/linux-hardkernel-4.14.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
        kernelPatches.modinst_arg_list_too_long
      ];
    };

    linux_zen = callPackage ../os-specific/linux/kernel/linux-zen.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_lqx = callPackage ../os-specific/linux/kernel/linux-lqx.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_xanmod = callPackage ../os-specific/linux/kernel/linux-xanmod.nix {
      kernelPatches = [
        kernelPatches.bridge_stp_helper
        kernelPatches.request_key_helper
      ];
    };

    linux_libre = deblobKernel packageAliases.linux_default.kernel;

    linux_latest_libre = deblobKernel packageAliases.linux_latest.kernel;

    linux_hardened = hardenedKernelFor packageAliases.linux_default.kernel { };

    linux_4_14_hardened = hardenedKernelFor kernels.linux_4_14 { };
    linux_4_19_hardened = hardenedKernelFor kernels.linux_4_19 { };
    linux_5_4_hardened = hardenedKernelFor kernels.linux_5_4 { };
    linux_5_10_hardened = hardenedKernelFor kernels.linux_5_10 { };
    linux_5_14_hardened = hardenedKernelFor kernels.linux_5_14 { };

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

    acpi_call = callPackage ../os-specific/linux/acpi-call {};

    akvcam = callPackage ../os-specific/linux/akvcam { };

    amdgpu-pro = callPackage ../os-specific/linux/amdgpu-pro { };

    anbox = callPackage ../os-specific/linux/anbox/kmod.nix { };

    apfs = callPackage ../os-specific/linux/apfs { };

    batman_adv = callPackage ../os-specific/linux/batman-adv {};

    bcc = callPackage ../os-specific/linux/bcc {
      python = pkgs.python3;
    };

    bpftrace = callPackage ../os-specific/linux/bpftrace { };

    bbswitch = callPackage ../os-specific/linux/bbswitch {};

    chipsec = callPackage ../tools/security/chipsec {
      inherit kernel;
      withDriver = true;
    };

    cryptodev = callPackage ../os-specific/linux/cryptodev { };

    cpupower = callPackage ../os-specific/linux/cpupower { };

    ddcci-driver = callPackage ../os-specific/linux/ddcci { };

    digimend = callPackage ../os-specific/linux/digimend { };

    dpdk-kmods = callPackage ../os-specific/linux/dpdk-kmods { };

    exfat-nofuse = callPackage ../os-specific/linux/exfat { };

    evdi = callPackage ../os-specific/linux/evdi { };

    fwts-efi-runtime = callPackage ../os-specific/linux/fwts/module.nix { };

    gcadapter-oc-kmod = callPackage ../os-specific/linux/gcadapter-oc-kmod { };
    hid-nintendo = callPackage ../os-specific/linux/hid-nintendo { };

    hyperv-daemons = callPackage ../os-specific/linux/hyperv-daemons { };

    e1000e = if lib.versionOlder kernel.version "4.10" then  callPackage ../os-specific/linux/e1000e {} else null;

    intel-speed-select = if lib.versionAtLeast kernel.version "5.3" then callPackage ../os-specific/linux/intel-speed-select { } else null;

    ixgbevf = callPackage ../os-specific/linux/ixgbevf {};

    it87 = callPackage ../os-specific/linux/it87 {};

    asus-wmi-sensors = callPackage ../os-specific/linux/asus-wmi-sensors {};

    ena = callPackage ../os-specific/linux/ena {};

    v4l2loopback = callPackage ../os-specific/linux/v4l2loopback { };

    lttng-modules = callPackage ../os-specific/linux/lttng-modules { };

    broadcom_sta = callPackage ../os-specific/linux/broadcom-sta { };

    tbs = callPackage ../os-specific/linux/tbs { };

    mbp2018-bridge-drv = callPackage ../os-specific/linux/mbp-modules/mbp2018-bridge-drv { };

    nvidiabl = callPackage ../os-specific/linux/nvidiabl { };

    nvidiaPackages = dontRecurseIntoAttrs (callPackage ../os-specific/linux/nvidia-x11 { });

    nvidia_x11_legacy340   = nvidiaPackages.legacy_340;
    nvidia_x11_legacy390   = nvidiaPackages.legacy_390;
    nvidia_x11_legacy470   = nvidiaPackages.legacy_470;
    nvidia_x11_beta        = nvidiaPackages.beta;
    nvidia_x11_vulkan_beta = nvidiaPackages.vulkan_beta;
    nvidia_x11             = nvidiaPackages.stable;

    openrazer = callPackage ../os-specific/linux/openrazer/driver.nix { };

    ply = callPackage ../os-specific/linux/ply { };

    r8125 = callPackage ../os-specific/linux/r8125 { };

    r8168 = callPackage ../os-specific/linux/r8168 { };

    rtl8188eus-aircrack = callPackage ../os-specific/linux/rtl8188eus-aircrack { };

    rtl8192eu = callPackage ../os-specific/linux/rtl8192eu { };

    rtl8723bs = callPackage ../os-specific/linux/rtl8723bs { };

    rtl8812au = callPackage ../os-specific/linux/rtl8812au { };

    rtl8814au = callPackage ../os-specific/linux/rtl8814au { };

    rtl88xxau-aircrack = callPackage ../os-specific/linux/rtl88xxau-aircrack {};

    rtl8821au = callPackage ../os-specific/linux/rtl8821au { };

    rtl8821ce = callPackage ../os-specific/linux/rtl8821ce { };

    rtl88x2bu = callPackage ../os-specific/linux/rtl88x2bu { };

    rtl8821cu = callPackage ../os-specific/linux/rtl8821cu { };

    rtw88 = callPackage ../os-specific/linux/rtw88 { };
    rtlwifi_new = rtw88;

    rtw89 = callPackage ../os-specific/linux/rtw89 { };

    openafs_1_8 = callPackage ../servers/openafs/1.8/module.nix { };
    openafs_1_9 = callPackage ../servers/openafs/1.9/module.nix { };
    # Current stable release; don't backport release updates!
    openafs = openafs_1_8;

    facetimehd = callPackage ../os-specific/linux/facetimehd { };

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

    oci-seccomp-bpf-hook = if lib.versionAtLeast kernel.version "5.4" then callPackage ../os-specific/linux/oci-seccomp-bpf-hook { } else null;

    perf = if lib.versionAtLeast kernel.version "3.12" then callPackage ../os-specific/linux/kernel/perf.nix { } else null;

    phc-intel = if lib.versionAtLeast kernel.version "4.10" then callPackage ../os-specific/linux/phc-intel { } else null;

    # Disable for kernels 4.15 and above due to compatibility issues
    prl-tools = if lib.versionOlder kernel.version "4.15" then callPackage ../os-specific/linux/prl-tools { } else null;

    sch_cake = callPackage ../os-specific/linux/sch_cake { };

    isgx = callPackage ../os-specific/linux/isgx { };

    rr-zen_workaround = callPackage ../development/tools/analysis/rr/zen_workaround.nix { };

    sysdig = callPackage ../os-specific/linux/sysdig {};

    systemtap = callPackage ../development/tools/profiling/systemtap { };

    system76 = callPackage ../os-specific/linux/system76 { };

    system76-acpi = callPackage ../os-specific/linux/system76-acpi { };

    system76-power = callPackage ../os-specific/linux/system76-power { };

    system76-io = callPackage ../os-specific/linux/system76-io { };

    tmon = callPackage ../os-specific/linux/tmon { };

    tp_smapi = callPackage ../os-specific/linux/tp_smapi { };

    turbostat = callPackage ../os-specific/linux/turbostat { };

    usbip = callPackage ../os-specific/linux/usbip { };

    v86d = callPackage ../os-specific/linux/v86d { };

    veikk-linux-driver = callPackage ../os-specific/linux/veikk-linux-driver { };
    vendor-reset = callPackage ../os-specific/linux/vendor-reset { };

    vhba = callPackage ../misc/emulators/cdemu/vhba.nix { };

    virtualbox = callPackage ../os-specific/linux/virtualbox {
      virtualbox = pkgs.virtualboxHardened;
    };

    virtualboxGuestAdditions = callPackage ../applications/virtualization/virtualbox/guest-additions {
      virtualbox = pkgs.virtualboxHardened;
    };

    vm-tools = callPackage ../os-specific/linux/vm-tools { };

    wireguard = if lib.versionOlder kernel.version "5.6" then callPackage ../os-specific/linux/wireguard { } else null;

    x86_energy_perf_policy = callPackage ../os-specific/linux/x86_energy_perf_policy { };

    xmm7360-pci = callPackage ../os-specific/linux/xmm7360-pci { };

    xpadneo = callPackage ../os-specific/linux/xpadneo { };

    zenpower = callPackage ../os-specific/linux/zenpower { };

    inherit (callPackage ../os-specific/linux/zfs {
        configFile = "kernel";
        inherit pkgs kernel;
      }) zfsStable zfsUnstable;
    zfs = zfsStable;

    can-isotp = callPackage ../os-specific/linux/can-isotp { };

  } // lib.optionalAttrs (config.allowAliases or false) {
    ati_drivers_x11 = throw "ati drivers are no longer supported by any kernel >=4.1"; # added 2021-05-18;
  });

  hardenedPackagesFor = kernel: overrides: packagesFor (hardenedKernelFor kernel overrides);

  vanillaPackages = {
    # recurse to build modules for the kernels
    linux_4_4 = recurseIntoAttrs (packagesFor kernels.linux_4_4);
    linux_4_9 = recurseIntoAttrs (packagesFor kernels.linux_4_9);
    linux_4_14 = recurseIntoAttrs (packagesFor kernels.linux_4_14);
    linux_4_19 = recurseIntoAttrs (packagesFor kernels.linux_4_19);
    linux_5_4 = recurseIntoAttrs (packagesFor kernels.linux_5_4);
    linux_5_10 = recurseIntoAttrs (packagesFor kernels.linux_5_10);
    linux_5_14 = recurseIntoAttrs (packagesFor kernels.linux_5_14);
    linux_5_15 = recurseIntoAttrs (packagesFor kernels.linux_5_15);
  };

  rtPackages = {
     # realtime kernel packages
     linux_rt_5_4 = packagesFor kernels.linux_rt_5_4;
     linux_rt_5_10 = packagesFor kernels.linux_rt_5_10;
     linux_rt_5_11 = packagesFor kernels.linux_rt_5_11;
  };

  rpiPackages = {
    linux_rpi1 = packagesFor kernels.linux_rpi1;
    linux_rpi2 = packagesFor kernels.linux_rpi2;
    linux_rpi3 = packagesFor kernels.linux_rpi3;
    linux_rpi4 = packagesFor kernels.linux_rpi4;
  };

  packages = recurseIntoAttrs (vanillaPackages // rtPackages // rpiPackages // {
    linux_mptcp_95 = packagesFor kernels.linux_mptcp_95;

    # Intentionally lacks recurseIntoAttrs, as -rc kernels will quite likely break out-of-tree modules and cause failed Hydra builds.
    linux_testing = packagesFor kernels.linux_testing;
    linux_testing_bcachefs = recurseIntoAttrs (packagesFor kernels.linux_testing_bcachefs);

    linux_hardened = recurseIntoAttrs (hardenedPackagesFor packageAliases.linux_default.kernel { });

    linux_4_14_hardened = recurseIntoAttrs (hardenedPackagesFor kernels.linux_4_14 { });
    linux_4_19_hardened = recurseIntoAttrs (hardenedPackagesFor kernels.linux_4_19 { });
    linux_5_4_hardened = recurseIntoAttrs (hardenedPackagesFor kernels.linux_5_4 { });
    linux_5_10_hardened = recurseIntoAttrs (hardenedPackagesFor kernels.linux_5_10 { });
    linux_5_14_hardened = recurseIntoAttrs (hardenedPackagesFor kernels.linux_5_14 { });

    linux_zen = recurseIntoAttrs (packagesFor kernels.linux_zen);
    linux_lqx = recurseIntoAttrs (packagesFor kernels.linux_lqx);
    linux_xanmod = recurseIntoAttrs (packagesFor kernels.linux_xanmod);

    hardkernel_4_14 = recurseIntoAttrs (packagesFor kernels.linux_hardkernel_4_14);

    linux_libre = recurseIntoAttrs (packagesFor kernels.linux_libre);

    linux_latest_libre = recurseIntoAttrs (packagesFor kernels.linux_latest_libre);
  });

  packageAliases = {
    linux_default = packages.linux_5_10;
    # Update this when adding the newest kernel major version!
    linux_latest = packages.linux_5_15;
    linux_mptcp = packages.linux_mptcp_95;
    linux_rt_default = packages.linux_rt_5_4;
    linux_rt_latest = packages.linux_rt_5_11;
    linux_hardkernel_latest = packages.hardkernel_4_14;
  };

  manualConfig = makeOverridable (callPackage ../os-specific/linux/kernel/manual-config.nix {});

  customPackage = { version, src, configfile, allowImportFromDerivation ? true }:
    recurseIntoAttrs (packagesFor (manualConfig {
      inherit version src configfile lib stdenv allowImportFromDerivation;
    }));

  # Derive one of the default .config files
  linuxConfig = {
    src,
    version ? (builtins.parseDrvName src.name).version,
    makeTarget ? "defconfig",
    name ? "kernel.config",
  }: stdenvNoCC.mkDerivation {
    inherit name src;
    depsBuildBuild = [ buildPackages.stdenv.cc ]
      ++ lib.optionals (lib.versionAtLeast version "4.16") [ buildPackages.bison buildPackages.flex ];
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

  buildLinux = attrs: callPackage ../os-specific/linux/kernel/generic.nix attrs;

}
