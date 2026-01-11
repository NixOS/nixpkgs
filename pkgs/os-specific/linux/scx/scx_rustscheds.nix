{
  lib,
  rustPlatform,
  llvmPackages,
  pkg-config,
  elfutils,
  zlib,
  zstd,
  fetchFromGitHub,
  protobuf,
  libseccomp,
  nix-update-script,
  nixosTests,
  fetchpatch,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scx_rustscheds";
  version = "1.0.19";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bOldw2Sob5aANmVzw6VwCgJ4+VzEsohKUxOxntow7VY=";
  };

  cargoHash = "sha256-ik05X+5jIdxtXYhN6fb1URW8TKKzgFuevi5+Wm2j15Y=";

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/sched-ext/scx/pull/3127.patch";
      hash = "sha256-HpGJR3eBZKE+VsqGivjJp1n7JIORhZUxG87AsP1WWi0=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    protobuf
  ];
  buildInputs = [
    elfutils
    zlib
    zstd
    libseccomp
  ];

  env = {
    BPF_CLANG = lib.getExe llvmPackages.clang;
    RUSTFLAGS = lib.concatStringsSep " " [
      "-C relocation-model=pic"
      "-C link-args=-lelf"
      "-C link-args=-lz"
      "-C link-args=-lzstd"
    ];
  };

  hardeningDisable = [
    "zerocallusedregs"
  ];

  doCheck = true;
  checkFlags = [
    "--skip=compat::tests::test_ksym_exists"
    "--skip=compat::tests::test_read_enum"
    "--skip=compat::tests::test_struct_has_field"
    "--skip=cpumask"
    "--skip=topology"
    "--skip=proc_data::tests::test_thread_operations"
    "--skip=json::tests::test_with_resources"
    "--skip=json::tests::test_with_dir"
  ];

  passthru.tests.basic = nixosTests.scx;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sched-ext Rust userspace schedulers";
    longDescription = ''
      This includes Rust based schedulers such as
      scx_rustland, scx_bpfland, scx_lavd, scx_layered, scx_rlfifo.

      ::: {.note}
      Sched-ext schedulers are only available on kernels version 6.12 or later.
      It is recommended to use the latest kernel for the best compatibility.
      :::
    '';

    homepage = "https://github.com/sched-ext/scx/tree/main/scheds/rust";
    changelog = "https://github.com/sched-ext/scx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
    maintainers = with lib.maintainers; [
      johnrtitor
      Gliczy
    ];
  };
})
