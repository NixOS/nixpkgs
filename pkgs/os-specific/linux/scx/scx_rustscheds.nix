{
  lib,
  rustPlatform,
  llvmPackages,
  pkg-config,
  elfutils,
  zlib,
  zstd,
  scx-common,
  protobuf,
  libseccomp,
}:
rustPlatform.buildRustPackage {
  pname = "scx_rustscheds";
  inherit (scx-common) version src;

  inherit (scx-common.versionInfo.scx) cargoHash;

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
    "stackprotector"
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

  meta = scx-common.meta // {
    description = "Sched-ext Rust userspace schedulers";
    longDescription = ''
      This includes Rust based schedulers such as
      scx_rustland, scx_bpfland, scx_lavd, scx_layered, scx_rlfifo.

      ::: {.note}
      Sched-ext schedulers are only available on kernels version 6.12 or later.
      It is recommended to use the latest kernel for the best compatibility.
      :::
    '';
  };
}
