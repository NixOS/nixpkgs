# Adapted from linux-testing
{ lib, buildLinux, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.19-rc5-enarx-5";
  modDirVersion = "5.19.0-rc5-next-20220706";
  extraMeta.branch = lib.versions.majorMinor version;
  extraMeta.maintainers = with lib.maintainers; [ rvolosatovs ];

  src = builtins.fetchTarball {
    url = "https://github.com/enarx/linux/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-MSlkHprFP2HDV/xZxfqYFxXuiclpypq27wKDrbzG6YM=";
  };

  structuredExtraConfig = with lib.kernel; {
    "64BIT" = yes;
    ACPI = yes;
    AMD_IOMMU_V2 = yes;
    AMD_MEM_ENCRYPT = yes;
    CRYPTO = yes;
    CRYPTO_DEV_CCP = yes;
    CRYPTO_DEV_CCP_CRYPTO = module;
    CRYPTO_DEV_CCP_DD = module;
    CRYPTO_DEV_SP_CCP = yes;
    CRYPTO_DEV_SP_PSP = yes;
    DMADEVICES = yes;
    GART_IOMMU = yes;
    HIGH_RES_TIMERS = yes;
    INIT_ON_ALLOC_DEFAULT_ON = yes;
    INTEGRITY_ASYMMETRIC_KEYS = yes;
    INTEGRITY_SIGNATURE = yes;
    INTEL_IOMMU_SVM = yes;
    INTEL_TURBO_MAX_3 = yes;
    INTEL_TXT = yes;
    IOMMU_HELPER = yes;
    IOMMU_SVA = yes;
    KVM = yes;
    KVM_AMD = module;
    KVM_AMD_SEV = yes;
    KVM_INTEL = module;
    MEMORY_FAILURE = yes;
    MODVERSIONS = yes;
    PACKET = yes;
    PCI = yes;
    RETPOLINE = yes;
    SECURITY_DMESG_RESTRICT = yes;
    SECURITY_NETWORK_XFRM=yes;
    SEV_GUEST = yes;
    VIRTUALIZATION = yes;
    X86_CPU_RESCTRL = yes;
    X86_MCE = yes;
    X86_SGX = yes;
    X86_SGX_KVM = yes;
  };
 } // (args.argsOverride or {}))
