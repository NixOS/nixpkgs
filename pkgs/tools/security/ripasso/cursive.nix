{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config, python3, openssl, libgpg-error, gpgme, xorg, nettle, llvmPackages, clang, AppKit, Security, installShellFiles }:

with rustPlatform;
buildRustPackage rec {
  version = "0.6.2";
  pname = "ripasso-cursive";

  src = fetchFromGitHub {
    owner = "cortex";
    repo = "ripasso";
    rev  = "release-${version}";
    sha256 = "sha256-OKFgBfm4d9IqSJFjg+J1XdsgQrfuIaoRIhVJQeZ+558=";
  };

  patches = [ ./fix-tests.patch ./build-on-macos.patch ];

  # Needed so bindgen can find libclang.so
  LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "qml-0.0.9" = "sha256-ILqvUaH7nSu2JtEs8ox7KroOzYnU5ai44k1HE4Bz5gg=";
    };
  };

  cargoBuildFlags = [ "-p ripasso-cursive" ];

  nativeBuildInputs = [ pkg-config gpgme python3 installShellFiles clang ];
  buildInputs = [
    openssl libgpg-error gpgme xorg.libxcb nettle
  ] ++ lib.optionals stdenv.isDarwin [ AppKit Security ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  postInstall = ''
    installManPage target/man-page/cursive/ripasso-cursive.1
  '';

  meta = with lib; {
    description = "A simple password manager written in Rust";
    homepage = "https://github.com/cortex/ripasso";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sgo ];
    platforms = platforms.unix;
  };
}
