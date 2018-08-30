{ stdenv, fetchFromGitHub, xcbuildHook, libiconv, Cocoa, ncurses }:

stdenv.mkDerivation rec {
  name = "pinentry-mac-0.9.4";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "pinentry-mac";
    rev = "6dfef256c8ea32d642fea847f27d800f024cf51e";
    sha256 = "0g75302697gqcxyf2hyqzvcbd5pyss1bl2xvfd40wqav7dlyvj83";
  };

  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ libiconv Cocoa ncurses ];

  installPhase = ''
    mkdir -p $out/Applications
    mv Products/Release/pinentry-mac.app $out/Applications
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
