{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  bison,
  boost182,
  flex,
  fmt,
  gtest,
  libbacktrace,
  lit,
  llvmPackages,
  meson,
  ninja,
  nix,
  nixpkgs-fmt,
  pkg-config,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixd";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixd";
    rev = finalAttrs.version;
    hash = "sha256-A6hoZ4fbWxd7Mx+r3e1HEw2IPaAn4WcMEIocy/ZCz28=";
  };

  mesonBuildType = "release";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    bison
    flex
  ];

  nativeCheckInputs = [
    lit
    nixpkgs-fmt
  ];

  buildInputs = [
    libbacktrace
    nix
    fmt
    gtest
    boost182
    llvmPackages.llvm
  ];

  env.CXXFLAGS = "-include ${nix.dev}/include/nix/config.h";

  # https://github.com/nix-community/nixd/issues/215
  doCheck = !stdenv.isDarwin;

  checkPhase = ''
    runHook preCheck
    dirs=(store var var/nix var/log/nix etc home)

    for dir in $dirs; do
      mkdir -p "$TMPDIR/$dir"
    done

    export NIX_STORE_DIR=$TMPDIR/store
    export NIX_LOCALSTATE_DIR=$TMPDIR/var
    export NIX_STATE_DIR=$TMPDIR/var/nix
    export NIX_LOG_DIR=$TMPDIR/var/log/nix
    export NIX_CONF_DIR=$TMPDIR/etc
    export HOME=$TMPDIR/home

    # Disable nixd regression tests, because it uses some features provided by
    # nix, and does not correctly work in the sandbox
    meson test --print-errorlogs  unit/libnixf/Basic unit/libnixf/Parse unit/libnixt
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [
        "libnixf"
        "libnixt"
      ];
    };
  };

  meta = {
    description = "Nix language server";
    homepage = "https://github.com/nix-community/nixd";
    changelog = "https://github.com/nix-community/nixd/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      inclyc
      Ruixi-rebirth
    ];
    mainProgram = "nixd";
    platforms = lib.platforms.unix;
  };
})
