{ stdenv, fetchFromGitHub, premake4, bootil }:

stdenv.mkDerivation rec {
  name = "gmad-unstable-2015-04-16";

  meta = {
    description = "Garry's Mod Addon Creator and Extractor";
    homepage = https://github.com/garrynewman/gmad;
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.abigailbuccaneer ];
    platforms = stdenv.lib.platforms.all;
  };

  src = fetchFromGitHub {
    owner = "garrynewman";
    repo = "gmad";
    rev = "377f3458bf1ecb8a1a2217c2194773e3c2a2dea0";
    sha256="0myi9njr100gxhxk1vrzr2sbij5kxl959sq0riiqgg01div338g0";
  };

  buildInputs = [ premake4 bootil ];

  targetName =
    if stdenv.isLinux then "gmad_linux"
    else if stdenv.isDarwin then "gmad_osx"
    else "gmad";

  premakeFlags = "--bootil_lib=${bootil}/lib --bootil_inc=${bootil}/include";

  installPhase = ''
    mkdir -p $out/bin
    cp ${targetName} $out/bin/gmad
  '';
}
