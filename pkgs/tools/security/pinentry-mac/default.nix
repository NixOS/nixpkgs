{ fetchurl, stdenv, fetchFromGitHub, xcbuild, libiconv, Cocoa, ncurses }:

stdenv.mkDerivation rec {
  name = "pinentry-mac-0.9.4";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "pinentry-mac";
    rev = "d60aa902644a1f0126ec50e79937423a3a7c3bc4";
    sha256 = "0xp4rdyj0mw6gg1z1wraggb1qlkjb5845mibrz3nj0l692da52nq";
  };

  buildInputs = [ xcbuild libiconv Cocoa ncurses ];

  dontUseXcbuild = true;

  installPhase = ''
    mkdir -p $out/Applications
    mv pinentry-mac-*/Build/Products/Release/pinentry-mac.app $out/Applications
  '';

  passthru = {
    binaryPath = "Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
  };

  meta = {
    description = "Pinentry for GPG on Mac";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = https://github.com/GPGTools/pinentry-mac;
    platforms = stdenv.lib.platforms.darwin;
  };
}
