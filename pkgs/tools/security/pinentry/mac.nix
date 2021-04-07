{ lib, stdenv, fetchFromGitHub, xcbuildHook, libiconv, ncurses, Cocoa }:

stdenv.mkDerivation {
  pname = "pinentry-mac";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "pinentry-mac";
    rev = "6dfef256c8ea32d642fea847f27d800f024cf51e";
    sha256 = "0g75302697gqcxyf2hyqzvcbd5pyss1bl2xvfd40wqav7dlyvj83";
  };

  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ libiconv ncurses Cocoa ];

  preBuild = ''
    # Only build for what we care about (also allows arm64)
    substituteInPlace pinentry-mac.xcodeproj/project.pbxproj \
      --replace "i386 x86_64 ppc" "${stdenv.targetPlatform.darwinArch}"
  '';

  installPhase = ''
    mkdir -p $out/Applications
    mv Products/Release/pinentry-mac.app $out/Applications
  '';

  passthru = {
    binaryPath = "Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac";
  };

  meta = {
    description = "Pinentry for GPG on Mac";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/GPGTools/pinentry-mac";
    platforms = lib.platforms.darwin;
  };
}
