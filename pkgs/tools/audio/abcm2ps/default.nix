{ stdenv, fetchFromGitHub, pkgconfig, which, docutils, freetype, pango }:

stdenv.mkDerivation rec {
  name = "abcm2ps-${version}";
  version = "8.14.0";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    sha256 = "1nlvq2cfdy5pghll3aprws7yx5p14gcrhz10q9fa6myrd8ad4if1";
  };

  prePatch = ''
    chmod +x configure
  '';

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
    description = "abcm2ps is a command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
  };
}
