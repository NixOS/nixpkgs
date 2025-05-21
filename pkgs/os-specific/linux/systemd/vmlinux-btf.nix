{
  lib,
  linuxManualConfig,
  linuxConfig,
  mergeKernelConfigs,
  linuxHeaders,
  bpftools,
  runCommand,
  writeText,
}:
let
  # Create a minimal kernel config file, which is sufficient for the BTF
  # that systemd uses.
  configfile =
    let
      baseConfig = linuxConfig {
        inherit (linuxHeaders) src;
        makeTarget = "allnoconfig";
      };
      extraConfig = writeText "systemd-btf.config" ''
        CONFIG_BPF=y
        CONFIG_BPF_SYSCALL=y
        CONFIG_BPF_JIT=y
        CONFIG_BPF_JIT_ALWAYS_ON=y
        CONFIG_BPF_JIT_DEFAULT_ON=y
        CONFIG_CGROUPS=y
        CONFIG_CGROUP_BPF=y
        CONFIG_DEBUG_KERNEL=y
        CONFIG_DEBUG_INFO=y
        CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
        CONFIG_DEBUG_INFO_BTF=y
      '';
    in
    mergeKernelConfigs {
      configs = [
        baseConfig
        extraConfig
      ];
      inherit (linuxHeaders) src;
    };

  # The actual kernel ELF.
  vmlinux = linuxManualConfig {
    inherit (linuxHeaders) version src;
    inherit configfile;
  };
in
runCommand "systemd-btf"
  {
    inherit (linuxHeaders) version;
    nativeBuildInputs = [
      bpftools
    ];
    meta.description = "BTF for systemd";
    passthru.kernel = vmlinux;
  }
  ''
    mkdir -p $out
    bpftool btf dump file ${vmlinux.dev}/vmlinux format c > $out/vmlinux.h
  ''
