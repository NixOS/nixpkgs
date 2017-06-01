{ stdenv, fetchFromGitHub, CoreServices }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "premake-${version}";
  version = "5.0.0pre.alpha.11";

  src = fetchFromGitHub {
    owner = "premake";
    repo = "premake-core";
    rev = "5dfb0238bc309df04819dd430def621ce854678d";
    sha256 = "0k9xbqrnbwj0hnmdgcrwn70py1kiqvr10l42aw42xnlmdyg1sgsc";
  };

  buildInputs = optional stdenv.isDarwin [ CoreServices ];

  patchPhase = optional stdenv.isDarwin ''
    substituteInPlace premake5.lua \
      --replace -mmacosx-version-min=10.4 -mmacosx-version-min=10.5
  '';

  buildPhase =
    if stdenv.isDarwin then ''
       make -f Bootstrap.mak osx
    '' else ''
       make -f Bootstrap.mak linux
    '';

  installPhase = ''
    install -Dm755 bin/release/premake5 $out/bin/premake5
  '';

  meta = {
    homepage = https://premake.github.io;
    description = "A simple build configuration and project generation tool using lua";
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
