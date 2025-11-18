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
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scx_rustscheds";
  version = "1.0.18";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RkTY7gDcKbkNUKl7NJDX3Ac/I+dRG1Gj8rRHynbbxUU=";
  };

  cargoHash = "sha256-tuZhqDT1xMP+Pufwz6SBt44qNzHuGzcU9QmVNIg2zS0=";

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
