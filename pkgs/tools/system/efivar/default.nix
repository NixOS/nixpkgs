{ stdenv, buildPackages, fetchFromGitHub, fetchurl, pkgconfig, popt }:

stdenv.mkDerivation rec {
  pname = "efivar";
  version = "37";

  outputs = [ "bin" "out" "dev" "man" ];

  src = fetchFromGitHub {
    owner = "rhinstaller";
    repo = "efivar";
    rev = version;
    sha256 = "1z2dw5x74wgvqgd8jvibfff0qhwkc53kxg54v12pzymyibagwf09";
  };
  patches = [
    (fetchurl {
      name = "r13y.patch";
      url = "https://patch-diff.githubusercontent.com/raw/rhboot/efivar/pull/133.patch";
      sha256 = "038cwldb8sqnal5l6mhys92cqv8x7j8rgsl8i4fiv9ih9znw26i6";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
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

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Tools and library to manipulate EFI variables";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
