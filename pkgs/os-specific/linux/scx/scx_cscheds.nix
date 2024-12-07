{
  lib,
  llvmPackages,
  fetchFromGitHub,
  fetchpatch,
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
}:

let
  # Fixes a bug with the meson build script where it specifies
  # /bin/bash twice in the script
  misbehaviorBash = writeShellScript "bash" ''
    shift 1
    exec ${lib.getExe bash} "$@"
  '';

in
llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "scx_cscheds";
  inherit (scx-common) version src;

  patches = [
    # TODO: remove at the next point release
    (fetchpatch {
      url = "https://github.com/sched-ext/scx/commit/22d45e6ddbea81efc17a91ca6d713a7e396cea52.patch?full_index=1";
      hash = "sha256-SLSQNqRpKNT1HuuuT1h+fR1o3nbbVpfRCB30cFieIeg=";
    })
    (fetchpatch {
      url = "https://github.com/sched-ext/scx/commit/a72c24e7e5670b4533c4508d6d6c980d8487cb50.patch?full_index=1";
      hash = "sha256-RUo7tl3V8iPN/fEm0oyj8UBwiWdna/ttZh+/OtcvflE=";
    })
    (fetchpatch {
      url = "https://github.com/sched-ext/scx/commit/21cf3ccd1d263cf7aac3afe337911f18ba329dca.patch?full_index=1";
      hash = "sha256-vOHM+1QvVxI89azqoIrOhjfSyYHTMGuIWAAupcGQ7Oc=";
    })
  ];

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
    substituteInPlace meson.build \
      --replace-fail '[build_bpftool' "['${misbehaviorBash}', build_bpftool"
  '';

  nativeBuildInputs = [
    meson
    ninja
    jq
    pkg-config
    zstd
  ] ++ bpftools.buildInputs ++ bpftools.nativeBuildInputs;

  buildInputs = [
    elfutils
    zlib
  ];

  mesonFlags = [
    (lib.mapAttrsToList lib.mesonEnable {
      # systemd unit is implemented in the nixos module
      # upstream systemd files are a hassle to patch
      "systemd" = false;
      # not for nix
      "openrc" = false;
      "libalpm" = false;
    })
    (lib.mapAttrsToList lib.mesonBool {
      # needed libs are already fetched as FOD
      "offline" = true;
      # rust based schedulers are built seperately
      "enable_rust" = false;
    })
    # Clang to use when compiling .bpf.c
    (lib.mesonOption "bpf_clang" (lib.getExe llvmPackages.clang))
  ];

  hardeningDisable = [
    "stackprotector"
    "zerocallusedregs"
  ];

  # We copy the compiled header files to the dev output
  # These are needed for the rust schedulers
  preInstall = ''
    mkdir -p ${placeholder "dev"}/libbpf ${placeholder "dev"}/bpftool
    cp -r libbpf/* ${placeholder "dev"}/libbpf/
    cp -r bpftool/* ${placeholder "dev"}/bpftool/
  '';

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  # Enable this when default kernel in nixpkgs is 6.12+
  doCheck = false;

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
