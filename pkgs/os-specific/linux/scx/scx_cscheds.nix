{
  stdenv,
  lib,
  mkScxScheduler,
  fetchFromGitHub,
  writeShellScript,
  bash,
  meson,
  ninja,
  jq,
  bpftools,
  elfutils,
  zlib,
  zstd,
}:

let
  versionInfo = lib.importJSON ./version.json;

  # scx needs a specific commit of bpftool and libbpf
  # can be found in meson.build of scx src
  # grep 'bpftool_commit =' ./meson.build
  bpftools_src = fetchFromGitHub {
    owner = "libbpf";
    repo = "bpftool";
    inherit (versionInfo.bpftool) rev hash;
    fetchSubmodules = true;
  };
  # grep 'libbpf_commit = ' ./meson.build
  libbpf_src = fetchFromGitHub {
    owner = "libbpf";
    repo = "libbpf";
    inherit (versionInfo.libbpf) rev hash;
    fetchSubmodules = true;
  };

  # scx needs a specific commit of bpftool
  # this imitates the fetch_bpftool script in src/meson-scripts
  fetchBpftool = writeShellScript "fetch_bpftool" ''
    [ "$2" == '${bpftools_src.rev}' ] || exit 1
    cd "$1"
    cp --no-preserve=mode,owner -r "${bpftools_src}/" ./bpftool
  '';
  fetchLibbpf = writeShellScript "fetch_libbpf" ''
    [ "$2" == '${libbpf_src.rev}' ] || exit 1
    cd "$1"
    cp --no-preserve=mode,owner -r "${libbpf_src}/" ./libbpf
    mkdir -p ./libbpf/src/usr/include
  '';

  # Fixes a bug with the meson build script where it specifies
  # /bin/bash twice in the script
  misbehaviorBash = writeShellScript "bash" ''
    shift 1
    exec ${lib.getExe bash} "$@"
  '';

in
mkScxScheduler "c" {
  schedulerName = "scx_cscheds";

  postPatch = ''
    rm meson-scripts/fetch_bpftool meson-scripts/fetch_libbpf
    patchShebangs ./meson-scripts
    cp ${fetchBpftool} meson-scripts/fetch_bpftool
    cp ${fetchLibbpf} meson-scripts/fetch_libbpf
    substituteInPlace meson.build \
      --replace-fail '[build_bpftool' "['${misbehaviorBash}', build_bpftool"
  '';

  nativeBuildInputs = [
    meson
    ninja
    jq
  ] ++ bpftools.buildInputs ++ bpftools.nativeBuildInputs;

  buildInputs = [
    elfutils
    zlib
    zstd
  ];

  mesonFlags = [
    (lib.mapAttrsToList lib.mesonEnable {
      # systemd unit is implemented in the nixos module
      # upstream systemd files are a hassle to patch
      "systemd" = false;
      "openrc" = false;
      # not for nix
      "libalpm" = false;
    })
    (lib.mapAttrsToList lib.mesonBool {
      # needed libs are already fetched as FOD
      "offline" = true;
      # rust based schedulers are built seperately
      "enable_rust" = false;
    })
  ];

  hardeningDisable = [
    "stackprotector"
  ];

  meta = {
    description = "Sched-ext C userspace schedulers";
    longDescription = ''
      This includes C based schedulers such as scx_central, scx_flatcg,
      scx_nest, scx_pair, scx_qmap, scx_simple, scx_userland.
    '';
  };
}
