{ lib, stdenv, buildPackages, fetchFromGitHub, fetchpatch, pkg-config, popt, mandoc }:

stdenv.mkDerivation rec {
  pname = "efivar";
  version = "39";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "rhboot";
    repo = "efivar";
    rev = version;
    hash = "sha256-s/1k5a3n33iLmSpKQT5u08xoj8ypjf2Vzln88OBrqf0=";
  };

  nativeBuildInputs = [ pkg-config mandoc ];
  buildInputs = [ popt ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  makeFlags = [
    "prefix=$(out)"
    "libdir=$(out)/lib"
    "bindir=$(bin)/bin"
    "mandir=$(man)/share/man"
    "includedir=$(dev)/include"
    "PCDIR=$(dev)/lib/pkgconfig"
  ];

  meta = with lib; {
    description = "Tools and library to manipulate EFI variables";
    homepage = "https://github.com/rhboot/efivar";
    platforms = platforms.linux;
    license = licenses.lgpl21Only;
  };
}
