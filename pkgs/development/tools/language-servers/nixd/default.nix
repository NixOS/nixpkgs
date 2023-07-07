{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, bison
, boost182
, flex
, gtest
, libbacktrace
, lit
, llvmPackages
, meson
, ninja
, nix
, nixpkgs-fmt
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "nixd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixd";
    rev = version;
    hash = "sha256-zeBVh9gPMR+1ETx0ujl+TUSoeHHR4fkQfxyOpCDKP9M=";
  };

  patches = [
    # Fix build on Darwin. Remove with next release.
    # https://github.com/nix-community/nixd/pull/172
    (fetchpatch {
      url = "https://github.com/nix-community/nixd/commit/3dbe1eb6bde1949b510e19a2d1863a2f4d2329a6.patch";
      hash = "sha256-130L+85bZIBmNfHqH3PdmQCBuxLnCs3IyAAoW15RQSk=";
      includes = [ "lib/lspserver/src/Logger.cpp" "lib/nixd/src/ServerController.cpp" ];
    })
  ];

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
    gtest
    boost182
    llvmPackages.llvm
  ];

  env.CXXFLAGS = "-include ${nix.dev}/include/nix/config.h";

  doCheck = true;

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
    meson test --print-errorlogs server regression/nix-ast-dump
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nix language server";
    homepage = "https://github.com/nix-community/nixd";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ inclyc Ruixi-rebirth ];
    platforms = lib.platforms.unix;
  };
}
