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
  libbpf,
}:

let
  versionInfo = lib.importJSON ./version.json;

  # scx needs a specific commit of bpftool
  # can be found in meson.build of scx src
  # grep 'bpftool_commit =' ./meson.build
  bpftools_src = fetchFromGitHub {
    owner = "libbpf";
    repo = "bpftool";
    inherit (versionInfo.bpftool) rev hash;
    fetchSubmodules = true;
  };

  # scx needs a specific commit of bpftool
  # this imitates the fetch_bpftool script in src/meson-scripts
  fetchBpftool = writeShellScript "fetch_bpftool" ''
    [ "$2" == '${bpftools_src.rev}' ] || exit 1
    cd "$1"
    cp --no-preserve=mode,owner -r "${bpftools_src}/" ./bpftool
  '';

  # Fixes a bug with the meson build script where it specifies
  # /bin/bash twice in the script
  misbehaviorBash = writeShellScript "bash" ''
    shift 1
    exec ${lib.getExe bash} "$@"
  '';

  # Won't build with stable libbpf, so use the latest commit
  libbpf-git = libbpf.overrideAttrs (oldAttrs: {
    src = fetchFromGitHub {
      owner = "libbpf";
      repo = "libbpf";
      inherit (versionInfo.libbpf) rev hash;
      fetchSubmodules = true;
    };
  });

in
mkScxScheduler "c" {
  schedulerName = "scx_cscheds";

  postPatch = ''
    rm meson-scripts/fetch_bpftool
    patchShebangs ./meson-scripts
    cp ${fetchBpftool} meson-scripts/fetch_bpftool
    substituteInPlace meson.build \
      --replace-fail '[build_bpftool' "['${misbehaviorBash}', build_bpftool"
  '';

  nativeBuildInputs =
    [
      meson
      ninja
      jq
    ]
    ++ bpftools.buildInputs
    ++ bpftools.nativeBuildInputs;

  buildInputs = [
    elfutils
    zlib
    libbpf-git
  ];

  mesonFlags = [
    (lib.mapAttrsToList lib.mesonEnable {
      # systemd unit is implemented in the nixos module
      # upstream systemd files are a hassle to patch
      "systemd" = false;
      "openrc" = false;
      # libbpf is already fetched as FOD
      "libbpf_a" = false;
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
