{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config, ncurses, python3, openssl, libgpg-error, gpgme, xorg, AppKit, Security, installShellFiles }:

with rustPlatform;
buildRustPackage rec {
  version = "0.5.1";
  pname = "ripasso-cursive";

  src = fetchFromGitHub {
    owner = "cortex";
    repo = "ripasso";
    rev  = "release-${version}";
    sha256 = "1jx6qv7skikl1ap3g1r34rkz4ab756kra7dgwwv45vl2fb6x74k4";
  };

  patches = [ ./fix-tests.patch ];

  cargoSha256 = "1li1gmcs7lnjr4qhzs0rrgngdcxy1paiibjwk9zx2rrs71021cgk";

  cargoBuildFlags = [ "-p ripasso-cursive" ];

  nativeBuildInputs = [ pkg-config gpgme python3 installShellFiles ];
  buildInputs = [
    ncurses openssl libgpg-error gpgme xorg.libxcb
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
