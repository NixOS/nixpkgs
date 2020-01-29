{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, ncurses, python3, openssl, libgpgerror, gpgme, xorg, AppKit, Security }:

with rustPlatform;
buildRustPackage rec {
  version = "0.3.0";
  pname = "ripasso-cursive";

  src = fetchFromGitHub {
    owner = "cortex";
    repo = "ripasso";
    rev  = "release-${version}";
    sha256 = "1rkb23i9gcfmifcl31s8w86k7aza6nxrh3w33fvhv1ins1gxxk7w";
  };

  cargoSha256 = "1p0bsl4h2w257vfjbpqiga693gaslfq34g30dghpqb5n4kl416zp";

  cargoBuildFlags = [ "-p ripasso-cursive -p ripasso-man" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    ncurses python3 openssl libgpgerror gpgme xorg.libxcb
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ AppKit Security ];

  preFixup = ''
    mkdir -p "$out/man/man1"
    $out/bin/ripasso-man > $out/man/man1/ripasso-cursive.1
    rm $out/bin/ripasso-man
  '';

  meta = with stdenv.lib; {
    description = "A simple password manager written in Rust";
    homepage = "https://github.com/cortex/ripasso";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sgo ];
    platforms = platforms.unix;
  };
}
