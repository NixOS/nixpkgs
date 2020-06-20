{ stdenv, lib, rustPlatform, fetchFromGitHub, pkgconfig, ncurses, python3, openssl, libgpgerror, gpgme, xorg, AppKit, Security }:

with rustPlatform;
buildRustPackage rec {
  version = "0.4.0";
  pname = "ripasso-cursive";

  src = fetchFromGitHub {
    owner = "cortex";
    repo = "ripasso";
    rev  = "release-${version}";
    sha256 = "164da20j727p8l7hh37j2r8pai9sj402nhswvg0nrlgj53nr6083";
  };

  patches = [ ./fix-tests.patch ];

  cargoSha256 = "1wpn67v0xmxhn1dgzhh1pwz1yc3cizmfxhpb7qv9b27ynx4486ji";

  cargoBuildFlags = [ "-p ripasso-cursive -p ripasso-man" ];

  nativeBuildInputs = [ pkgconfig gpgme python3 ];
  buildInputs = [
    ncurses openssl libgpgerror gpgme xorg.libxcb
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
