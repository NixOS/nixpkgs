{ stdenv, fetchFromGitHub, pkgconfig, which, docutils, freetype, pango }:

stdenv.mkDerivation rec {
  pname = "abcm2ps";
  version = "8.14.7";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    sha256 = "0k12wf37vl31w2qpj3dsmv8c4ifrsg3qa30gqsx553jw7n0f3ma2";
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
