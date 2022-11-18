{ lib, stdenv, buildPackages, fetchFromGitHub, fetchpatch, pkg-config, popt, mandoc }:

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

  patches = [
    (fetchpatch {
      url = "https://github.com/rhboot/efivar/commit/15622b7e5761f3dde3f0e42081380b2b41639a48.patch";
      sha256 = "sha256-SjZXj0hA2eQu2MfBoNjFPtd2DMYadtL7ZqwjKSf2cmI=";
    })
  ];

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
