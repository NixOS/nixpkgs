{ lib, stdenv, fetchFromGitHub, pkg-config, which, docutils, freetype, pango }:

stdenv.mkDerivation rec {
  pname = "abcm2ps";
  version = "8.14.11";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    sha256 = "0lzzr2nkfg27gljcrdxkmli1wp08vap3vgxq1zgkv7f43rbm0qnw";
  };

  configureFlags = [
    "--INSTALL=install"
  ];

  buildFlags = [
    "CC=${stdenv.cc}/bin/cc"
  ];

  nativeBuildInputs = [ which pkg-config docutils ];

  buildInputs = [ freetype pango ];

  meta = with lib; {
    homepage = "http://moinejf.free.fr/";
    license = licenses.gpl3;
    description = "A command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
  };
}
