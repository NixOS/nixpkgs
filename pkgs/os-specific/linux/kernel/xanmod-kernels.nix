{
  lib,
  stdenv,
  fetchFromGitLab,
  buildLinux,
  variant,
  ...
}@args:

let
  # These names are how they are designated in https://xanmod.org.

  # NOTE: When updating these, please also take a look at the changes done to
  # kernel config in the xanmod version commit
  variants = {
    # ./update-xanmod.sh lts
    lts = {
      version = "6.12.60";
      hash = "sha256-nS9vsdH76q+uUaWXEp3duikX7osVqv7hjBMFNzdtA7o=";
      isLTS = true;
    };
    # ./update-xanmod.sh main
    main = {
      version = "6.17.9";
      hash = "sha256-M0M8jEflWgGMSUqQ2oEePISaYR5UIJbGrSmphCTIKYI=";
    };
  };

  xanmodKernelFor =
    {
      version,
      suffix ? "xanmod1",
      hash,
      isLTS ? false,
    }:
    buildLinux (
      args
      // rec {
        inherit version;
        pname = "linux-xanmod";
        modDirVersion = lib.versions.pad 3 "${version}-${suffix}";

        src = fetchFromGitLab {
          owner = "xanmod";
          repo = "linux";
          rev = modDirVersion;
          inherit hash;
        };

        structuredExtraConfig =
          with lib.kernel;
          {
            # CPUFreq governor Performance
            CPU_FREQ_DEFAULT_GOV_PERFORMANCE = lib.mkOverride 60 yes;
            CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = lib.mkOverride 60 no;

            # Preemption
            PREEMPT = lib.mkOverride 60 yes;
            PREEMPT_VOLUNTARY = lib.mkOverride 60 no;

            # Google's BBRv3 TCP congestion Control
            TCP_CONG_BBR = yes;
            DEFAULT_BBR = yes;

            # Preemptive tickless idle kernel
            HZ = freeform "250";
            HZ_250 = yes;
            NO_HZ = no;
            NO_HZ_FULL = lib.mkOverride 60 no;
            NO_HZ_IDLE = yes;

            # CPU idle governors favored
            CPU_IDLE_GOV_HALTPOLL = yes; # Already enabled
            CPU_IDLE_GOV_LADDER = yes;
            CPU_IDLE_GOV_TEO = yes;

            # RCU_BOOST and RCU_EXP_KTHREAD
            RCU_EXPERT = yes;
            RCU_FANOUT = freeform "64";
            RCU_FANOUT_LEAF = freeform "16";
            RCU_BOOST = yes;
            RCU_BOOST_DELAY = freeform "0";
            RCU_EXP_KTHREAD = yes;
            RCU_NOCB_CPU = yes;
            RCU_DOUBLE_CHECK_CB_TIME = yes;

            # x86 features
            X86_FRED = yes;
            X86_POSTED_MSI = yes;
          }
          // lib.optionalAttrs (lib.versionAtLeast (lib.versions.majorMinor version) "6.13") {
            # Lazy preemption
            PREEMPT = lib.mkOverride 70 no;
            PREEMPT_LAZY = yes;
          };

        extraPassthru.updateScript = {
          command = [
            ./update-xanmod.sh
            variant
          ];
          supportedFeatures = [
            "commit"
          ];
        };

        inherit isLTS;

        extraMeta = {
          branch = lib.versions.majorMinor version;
          maintainers = with lib.maintainers; [
            moni
            lovesegfault
            atemu
            zzzsy
            eljamm
          ];
          teams = [ ];
          description = "Built with custom settings and new features built to provide a stable, responsive and smooth desktop experience";
          broken = stdenv.hostPlatform.isAarch64;
        };
      }
      // (args.argsOverride or { })
    );
in
xanmodKernelFor variants.${variant}
