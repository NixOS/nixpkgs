{ stdenv, fetchFromGitHub, pkgconfig, which, freetype, pango }:

stdenv.mkDerivation rec {
  name = "abcm2ps-${version}";
  version = "8.13.23";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    sha256 = "00bc4vsdvnyznfwcrkij02n2736nsbjlrh0rng96zv00p4abv4ad";
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

  buildInputs = [ which pkgconfig freetype pango ];

  meta = with stdenv.lib; {
    homepage = http://moinejf.free.fr/;
    license = licenses.gpl3;
    description = "abcm2ps is a command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
  };
}
