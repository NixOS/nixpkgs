{ stdenv, fetchFromGitHub, pkgconfig, which, docutils, freetype, pango }:

stdenv.mkDerivation rec {
  name = "abcm2ps-${version}";
  version = "8.14.2";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    sha256 = "15hka82zps3rfp4xdbzlf23wz4hqjk084awzfjh357qn168bwwid";
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
