{ lib
, stdenv
, fetchFromGitHub
, docutils
, pkg-config
, freetype
, pango
}:

stdenv.mkDerivation rec {
  pname = "abcm2ps";
  version = "8.14.14";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    hash = "sha256-2BSbnziwlilYio9CF4MTlj0GVlkSpL8jeaqvLIBCeLQ=";
  };

  configureFlags = [
    "--INSTALL=install"
  ];

  nativeBuildInputs = [ docutils pkg-config ];

  buildInputs = [ freetype pango ];

  meta = with lib; {
    homepage = "http://moinejf.free.fr/";
    license = licenses.lgpl3Plus;
    description = "A command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
    mainProgram = "abcm2ps";
  };
}
