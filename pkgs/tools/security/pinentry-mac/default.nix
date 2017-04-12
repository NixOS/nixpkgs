{ fetchurl, stdenv, fetchFromGitHub, xcbuild, libiconv, Cocoa, ncurses }:

stdenv.mkDerivation rec {
  name = "pinentry-mac-0.9.4";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "pinentry-mac";
    rev = "77fc993d1040ed2319d9e53af78146be318c1fdd";
    sha256 = "0rkmp6wb8wvmhipavn1bdmbw6564hc2b99dxqysr6yxr2xqs6fcz";
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
    homepage = "https://github.com/GPGTools/pinentry-mac";
    platforms = stdenv.lib.platforms.darwin;
  };
}
