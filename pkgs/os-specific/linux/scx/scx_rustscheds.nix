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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kPOAiy2siIKZ6/zz43qPW7bp27T98MOhwmZMxpVpito=";
  };

  cargoHash = "sha256-nXiprz5ryGJeTy9nnKaLSKE0FSl17YE88xFt9bUTTL8=";

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

  # most of the tests rely on system CPU topology info,
  # which is not available in the sandbox
  doCheck = false;

  # we don't need these
  postInstall = ''
    rm $out/bin/{scx_arena_selftests,vmlinux_docify,xtask}
  '';

  __structuredAttrs = true;
  EXPECTED_SCHEDULERS = finalAttrs.passthru.schedulers;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    cd $out/bin
    found=(scx_*)
    if [[ "''${found[@]}" != "''${EXPECTED_SCHEDULERS[@]}" ]]; then
      echo "List of available schedulers changed, expected: ''${EXPECTED_SCHEDULERS[@]}, found: ''${found[@]}"
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru.tests.basic = nixosTests.scx;
  passthru.updateScript = nix-update-script { };
  passthru.schedulers = [
    "scx_beerland"
    "scx_bpfland"
    "scx_cake"
    "scx_chaos"
    "scx_cosmos"
    "scx_flash"
    "scx_lavd"
    "scx_layered"
    "scx_mitosis"
    "scx_p2dq"
    "scx_pandemonium"
    "scx_rlfifo"
    "scx_rustland"
    "scx_rusty"
    "scx_tickless"
    "scx_wd40"
  ];

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
