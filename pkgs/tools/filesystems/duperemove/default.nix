{ lib, stdenv, fetchFromGitHub, libgcrypt, pkgconfig, glib, linuxHeaders }:

stdenv.mkDerivation rec {
  name = "duperemove-${version}";
  version = "0.09.4";

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
    sha256 = "1d586k6rbfqb5557i1p5xq8ngbppbwpxlkw8wqm7d900a3hp36nl";
  };

  buildInputs = [ libgcrypt pkgconfig glib linuxHeaders ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  meta = {
    description = "A simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = https://github.com/markfasheh/duperemove;
    license = lib.licenses.gpl2;

    maintainers = [ lib.maintainers.bluescreen303 ];
    platforms = lib.platforms.all;
  };
}
