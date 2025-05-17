{
  lib,
  linuxManualConfig,
  linuxConfig,
  linuxHeaders,
  bpftools,
  runCommand,
}:
let
  # Create a minimal kernel config file, which is sufficient for the BTF
  # that systemd uses.
  configfile =
    (linuxConfig {
      inherit (linuxHeaders) src;
      makeTarget = "allnoconfig";
    }).overrideAttrs
      (oldAttrs: {
        buildPhase =
          oldAttrs.buildPhase
          + ''
            cat <<EOF >.config-fragment
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
            EOF

            ./scripts/kconfig/merge_config.sh .config .config-fragment
          '';
      });

  # The actual kernel ELF.
  vmlinux =
    (linuxManualConfig {
      inherit (linuxHeaders) version src;
      inherit configfile;
      modDirVersion = lib.versions.pad 3 linuxHeaders.version;
      allowImportFromDerivation = false;
    }).dev;
in
runCommand "systemd-btf"
  {
    version = linuxHeaders.version;
    nativeBuildInputs = [
      bpftools
    ];
    meta.description = "BTF for systemd";
  }
  ''
    mkdir -p $out
    bpftool btf dump file ${vmlinux}/vmlinux format c > $out/vmlinux.h
  ''
