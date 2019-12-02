{ stdenv, fetchFromGitHub, pkgconfig, which, docutils, freetype, pango }:

stdenv.mkDerivation rec {
  pname = "abcm2ps";
  version = "8.14.6";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    sha256 = "1gqjqbd8wj0655vi8gcg2r5jqzafdlnfjzwa9z331ywhrskpm53w";
  };

  configureFlags = [
    "--INSTALL=install"
  ];

  buildFlags = [
    "CC=${stdenv.cc}/bin/cc"
  ];

  nativeBuildInputs = [ which pkgconfig docutils ];

  buildInputs = [ freetype pango ];

  meta = with stdenv.lib; {
    homepage = http://moinejf.free.fr/;
    license = licenses.gpl3;
    description = "A command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
  };
}
