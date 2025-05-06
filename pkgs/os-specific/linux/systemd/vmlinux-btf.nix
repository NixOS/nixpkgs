{
  lib,
  linuxManualConfig,
  stdenv,
  linuxHeaders,
  bison,
  flex,
  pahole,
  bpftools,
}:
let
  # Create a minimal kernel config file, which is sufficient for the BTF
  # that systemd uses.
  configfile = stdenv.mkDerivation {
    name = "systemd-btf-config";
    inherit (linuxHeaders) version src;

    nativeBuildInputs = [
      bison
      flex
      pahole
    ];

    postPatch = ''
      patchShebangs scripts/
    '';

    buildPhase = ''
      make allnoconfig

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

    installPhase = ''
      cp .config $out
    '';
  };

  # The actual kernel ELF.
  vmlinux =
    (linuxManualConfig {
      inherit (linuxHeaders) version src;
      inherit configfile;
      modDirVersion = lib.versions.pad 3 linuxHeaders.version;
      allowImportFromDerivation = false;
    }).vmlinux;
in
stdenv.mkDerivation {
  name = "systemd-btf";
  version = linuxHeaders.version;

  dontUnpack = true;

  nativeBuildInputs = [
    bpftools
  ];

  buildPhase = ''
    mkdir -p $out
    bpftool btf dump file ${vmlinux}/vmlinux format c > $out/vmlinux.h
  '';

  meta.description = "BTF for systemd";
}
