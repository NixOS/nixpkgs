{
  lib,
  gccMultiStdenv,
  stdenv,
  fetchFromGitHub,
  bash,
  capnproto,
  cmake,
  coreutils,
  gdb,
  jq,
  libpfm,
  lldb,
  makeWrapper,
  nix-update-script,
  pkg-config,
  procps,
  python3,
  which,
  zlib,
  zstd,
}:
let
  stdenv' = if stdenv.hostPlatform.isx86_64 then gccMultiStdenv else stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  version = "5.10.0";
  pname = "rr";

  src = fetchFromGitHub {
    owner = "rr-debugger";
    repo = "rr";
    rev = finalAttrs.version;
    hash = "sha256-57g50US4WUvpPTKOllzfntHvScUmU5m/lbYqn9j80qY=";
  };

  postPatch = ''
    substituteInPlace src/Command.cc --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
    substituteInPlace src/test/{checksum_sanity,mremap_after_coalesce,signal_frame}.c \
      --replace-fail '"/bin/ls"' '"${lib.getExe' coreutils "ls"}"'
    patchShebangs src
  '';

  # With LTO enabled, linking fails with the following message:
  #
  # src/AddressSpace.cc:1666: undefined reference to `rr_syscall_addr'
  # ld.bfd: bin/rr: hidden symbol `rr_syscall_addr' isn't defined
  # ld.bfd: final link failed: bad value
  # collect2: error: ld returned 1 exit status
  #
  # See also https://github.com/NixOS/nixpkgs/pull/110846
  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace "-flto" ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    capnproto
    cmake
    makeWrapper
    pkg-config
    (python3.pythonOnBuildForHost.withPackages (ps: [ ps.pexpect ]))
    which
  ];

  buildInputs = [
    bash
    capnproto
    gdb
    libpfm
    procps
    python3
    zlib
    zstd
  ];

  nativeCheckInputs = [
    gdb
    jq
    lldb
    procps
  ];

  cmakeFlags = [
    (lib.cmakeBool "disable32bit" (!stdenv.hostPlatform.isx86_64))
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  # we turn on additional warnings due to hardening
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "fortify" ];

  # FIXME: checks were disabled with rr-5.7.0 (2023-10) and are not expected to
  # pass since they require hardware support on some machines. The update to
  # rr-5.10.0 (2026-10) fixed test deps: 60/3316 tests fail on a Zen 4 machine.
  doCheck = false;

  preCheck = "export HOME=$TMPDIR";

  # needs GDB to replay programs at runtime
  preFixup = ''
    wrapProgram "$out/bin/rr" \
      --prefix PATH ":" "${lib.makeBinPath [ gdb ]}";
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://rr-project.org/";
    description = "Records nondeterministic executions and debugs them deterministically";
    longDescription = ''
      rr aspires to be your primary debugging tool, replacing -- well,
      enhancing -- gdb. You record a failure once, then debug the
      recording, deterministically, as many times as you want. Every
      time the same execution is replayed.
    '';

    license = with lib.licenses; [
      mit
      bsd2
    ];
    maintainers = with lib.maintainers; [
      pierron
      thoughtpolice
      lf-
    ];
    platforms = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
