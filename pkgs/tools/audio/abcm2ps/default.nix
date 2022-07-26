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
  version = "8.14.13";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    hash = "sha256-31cEBtVn7GlNIsPkRiW0DyKA/giLeJ86EUZr8zjYy3s=";
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
  };
}
