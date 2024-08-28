{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, python3
, openssl
, libgpg-error
, gpgme
, xorg
, nettle
, clang
, AppKit
, Security
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  version = "0.6.4";
  pname = "ripasso-cursive";

  src = fetchFromGitHub {
    owner = "cortex";
    repo = "ripasso";
    rev = "release-${version}";
    hash = "sha256-9wBaFq2KVfLTd1j8ZPoUlmZJDW2UhvGBAaCGX+qg92s=";
  };

  patches = [
    ./fix-tests.patch
  ];

  cargoPatches = [
    ./fix-build.patch
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "qml-0.0.9" = "sha256-ILqvUaH7nSu2JtEs8ox7KroOzYnU5ai44k1HE4Bz5gg=";
    };
  };

  cargoBuildFlags = [ "-p ripasso-cursive" ];

  nativeBuildInputs = [
    pkg-config
    gpgme
    python3
    installShellFiles
    clang
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    libgpg-error
    gpgme
    xorg.libxcb
    nettle
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Security
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    installManPage target/man-page/cursive/ripasso-cursive.1
  '';

  meta = with lib; {
    description = "Simple password manager written in Rust";
    mainProgram = "ripasso-cursive";
    homepage = "https://github.com/cortex/ripasso";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sgo ];
    platforms = platforms.unix;
  };
}
