{ lib, stdenv, fetchFromGitHub, pkg-config, which, docutils, freetype, pango }:

stdenv.mkDerivation rec {
  pname = "abcm2ps";
  version = "8.14.12";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    sha256 = "sha256-RELWtI+S2cbG7cXCehXymvWRdair28UaDZRVr5xt9Tk=";
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
    license = licenses.lgpl3Plus;
    description = "A command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
  };
}
