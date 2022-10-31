{ lib, stdenv, buildPackages, fetchFromGitHub, pkg-config, popt, mandoc }:

stdenv.mkDerivation rec {
  pname = "efivar";
  version = "38";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    hash = "sha256-A38BKGMK3Vo+85wzgxmzTjzZXtpcY9OpbZaONWnMYNk=";
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
    inherit (src.meta) homepage;
    description = "Tools and library to manipulate EFI variables";
    platforms = platforms.linux;
    license = licenses.lgpl21Only;
  };
}
