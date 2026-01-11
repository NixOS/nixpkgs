{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  capnproto,
  cmake,
  gdb,
  libpfm,
  makeWrapper,
  nix-update-script,
  pkg-config,
  procps,
  python3,
  which,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "5.9.0";
  pname = "rr";

  src = fetchFromGitHub {
    owner = "rr-debugger";
    repo = "rr";
    rev = finalAttrs.version;
    hash = "sha256-o+HXrgGXdsvjlNh70qsXRtp2yXOiZIT30ejfs1KEaqE=";
  };

  postPatch = ''
    substituteInPlace src/Command.cc --replace '_BSD_SOURCE' '_DEFAULT_SOURCE'
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
    python3.pythonOnBuildForHost
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

  cmakeFlags = [
    (lib.cmakeBool "disable32bit" true)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  # we turn on additional warnings due to hardening
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "fortify" ];

  # FIXME
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
