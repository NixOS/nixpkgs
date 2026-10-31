{
  lib,
  version,
}:
let
  inherit (lib.kernel)
    freeform
    module
    no
    yes
    ;
in
{
  # CPUFreq governor Performance
  CPU_FREQ_DEFAULT_GOV_PERFORMANCE = lib.mkOverride 60 yes;
  CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = lib.mkOverride 60 no;

  # Preemption
  PREEMPT = lib.mkOverride 60 yes;

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

  # Canonical's Android Binder IPC driver, built as module
  ANDROID_BINDER_IPC = lib.mkOverride 60 module;
  ANDROID_BINDERFS = lib.mkOverride 60 module;
}
// lib.optionalAttrs (lib.versionOlder (lib.versions.majorMinor version) "7.0") {
  PREEMPT_VOLUNTARY = lib.mkOverride 60 no;
}
// lib.optionalAttrs (lib.versionAtLeast (lib.versions.majorMinor version) "6.13") {
  # Lazy preemption
  PREEMPT = lib.mkOverride 70 no;
  PREEMPT_LAZY = yes;
}
