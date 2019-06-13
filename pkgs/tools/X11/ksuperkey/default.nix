{ stdenv, fetchgit, libX11, libXtst, pkgconfig, xorgproto, libXi }:

stdenv.mkDerivation rec {
  name = "ksuperkey-git-2015-07-21";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libX11 libXtst xorgproto libXi
  ];

  src = fetchgit {
    url = "https://github.com/hanschen/ksuperkey";
    rev = "e75a31a0e3e80b14341e92799a7ce3232ac37639";
    sha256 = "0y4wkak9dvcm14g54ll1ln9aks2az63hx8fv7b8d3nscxjbkxl6g";
  };

  preConfigure = ''
    makeFlags="$makeFlags PREFIX=$out"
  '';

  meta = {
    description = "A tool to be able to bind the super key as a key rather than a modifier";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.vozz ];
    platforms = stdenv.lib.platforms.linux;
  };
}
