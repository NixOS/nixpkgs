{ stdenv, fetchFromGitHub, Foundation, readline }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "premake5-${version}";
  version = "5.0.0-alpha12";

  src = fetchFromGitHub {
    owner = "premake";
    repo = "premake-core";
    rev = "v${version}";
    sha256 = "1h3hr96pdz94njn4bg02ldcz0k5j1x017d8svc7fdyvl2b77nqzf";
  };

  buildInputs = optionals stdenv.isDarwin [ Foundation readline ];

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

  premake_cmd = "premake5";
  setupHook = ./setup-hook.sh;

  meta = {
    homepage = https://premake.github.io;
    description = "A simple build configuration and project generation tool using lua";
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
