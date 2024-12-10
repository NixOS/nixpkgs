{
  lib,
  stdenv,
  fetchFromGitHub,
  premake4,
  bootil,
}:

stdenv.mkDerivation rec {
  pname = "gmad";
  version = "unstable-2020-02-24";

  meta = {
    description = "Garry's Mod Addon Creator and Extractor";
    homepage = "https://github.com/Facepunch/gmad";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.abigailbuccaneer ];
    platforms = lib.platforms.all;
  };

  src = fetchFromGitHub {
    owner = "Facepunch";
    repo = "gmad";
    rev = "5236973a2fcbb3043bdd3d4529ce68b6d938ad93";
    sha256 = "04an17nvnj38mpi0w005v41ib8ynb5qhgrdkmsda4hq7l1gn276s";
  };

  buildInputs = [
    premake4
    bootil
  ];

  targetName =
    if stdenv.isLinux then
      "gmad_linux"
    else if stdenv.isDarwin then
      "gmad_osx"
    else
      "gmad";

  premakeFlags = [
    "--bootil_lib=${bootil}/lib"
    "--bootil_inc=${bootil}/include"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${targetName} $out/bin/gmad
  '';
}
