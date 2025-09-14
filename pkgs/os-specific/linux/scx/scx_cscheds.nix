{
  lib,
  llvmPackages,
  fetchFromGitHub,
  writeShellScript,
  bash,
  meson,
  ninja,
  jq,
  pkg-config,
  bpftools,
  elfutils,
  zlib,
  zstd,
  scx-common,
  protobuf,
  libseccomp,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "scx_cscheds";
  inherit (scx-common) version src;

  # scx needs specific commits of bpftool and libbpf
  # can be found in meson.build of scx src
  # grep 'bpftool_commit =' ./meson.build
  bpftools_src = fetchFromGitHub {
    owner = "libbpf";
    repo = "bpftool";
    inherit (scx-common.versionInfo.bpftool) rev hash;
    fetchSubmodules = true;
  };
  # grep 'libbpf_commit = ' ./meson.build
  libbpf_src = fetchFromGitHub {
    owner = "libbpf";
    repo = "libbpf";
    inherit (scx-common.versionInfo.libbpf) rev hash;
    fetchSubmodules = true;
  };

  # this imitates the fetch_bpftool and fetch_libbpf script in src/meson-scripts
  fetchBpftool = writeShellScript "fetch_bpftool" ''
    [ "$2" == '${finalAttrs.bpftools_src.rev}' ] || exit 1
    cd "$1"
    cp --no-preserve=mode,owner -r "${finalAttrs.bpftools_src}/" ./bpftool
  '';
  fetchLibbpf = writeShellScript "fetch_libbpf" ''
    [ "$2" == '${finalAttrs.libbpf_src.rev}' ] || exit 1
    cd "$1"
    cp --no-preserve=mode,owner -r "${finalAttrs.libbpf_src}/" ./libbpf
    mkdir -p ./libbpf/src/usr/include
  '';

  postPatch = ''
    rm meson-scripts/fetch_bpftool meson-scripts/fetch_libbpf
    patchShebangs ./meson-scripts
    cp ${finalAttrs.fetchBpftool} meson-scripts/fetch_bpftool
    cp ${finalAttrs.fetchLibbpf} meson-scripts/fetch_libbpf
    substituteInPlace ./meson-scripts/build_bpftool \
      --replace-fail '/bin/bash' '${lib.getExe bash}'
  '';

  nativeBuildInputs = [
    meson
    ninja
    jq
    pkg-config
    zstd
    protobuf
    llvmPackages.libllvm
  ]
  ++ bpftools.buildInputs
  ++ bpftools.nativeBuildInputs;

  buildInputs = [
    elfutils
    zlib
    libseccomp
  ];

  mesonFlags = [
    (lib.mapAttrsToList lib.mesonEnable {
      # systemd unit is implemented in the nixos module
      # upstream systemd files are a hassle to patch
      "systemd" = false;
      # not for nix
      "openrc" = false;
    })
    (lib.mapAttrsToList lib.mesonBool {
      # needed libs are already fetched as FOD
      "offline" = true;
      # rust based schedulers are built separately
      "enable_rust" = false;
    })
    # Clang to use when compiling .bpf.c
    (lib.mesonOption "bpf_clang" (lib.getExe llvmPackages.clang))
  ];

  hardeningDisable = [
    "stackprotector"
    "zerocallusedregs"
  ];

  outputs = [
    "bin"
    "out"
  ];

  doCheck = true;

  meta = scx-common.meta // {
    description = "Sched-ext C userspace schedulers";
    longDescription = ''
      This includes C based schedulers such as scx_central, scx_flatcg,
      scx_nest, scx_pair, scx_qmap, scx_simple, scx_userland.

      ::: {.note}
      Sched-ext schedulers are only available on kernels version 6.12 or later.
      It is recommended to use the latest kernel for the best compatibility.
      :::
    '';
  };
})
