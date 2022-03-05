{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config, ncurses, python3, openssl, libgpg-error, gpgme, xorg, AppKit, Security, installShellFiles }:

with rustPlatform;
buildRustPackage rec {
  version = "0.5.2";
  pname = "ripasso-cursive";

  src = fetchFromGitHub {
    owner = "cortex";
    repo = "ripasso";
    rev  = "release-${version}";
    sha256 = "sha256-De/xCDzdRHCslD0j6vT8bwjcMTf5R8KZ32aaB3i+Nig=";
  };

  patches = [ ./fix-tests.patch ];

  cargoSha256 = "sha256-ZmHzxHV4uIxPlLkkOLJApPNLo0GGVj9EopoIwi/j6DE=";

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
