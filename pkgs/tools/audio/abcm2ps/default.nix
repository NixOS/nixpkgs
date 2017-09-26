{ stdenv, fetchFromGitHub, pkgconfig, which, freetype, pango }:

stdenv.mkDerivation rec {
  name = "abcm2ps-${version}";
  version = "8.13.15";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcm2ps";
    rev = "v${version}";
    sha256 = "04j1s4ycd8siidj7xn7s0vwm5sj0qrhqr5qzpila2g8kjc4ldxml";
  };

  patchPhase = ''
    chmod +x configure
  '';

  configureFlags = [
    "--INSTALL=install"
  ];

  buildInputs = [ which pkgconfig freetype pango ];

  meta = with stdenv.lib; {
    homepage = http://moinejf.free.fr/;
    license = licenses.gpl3;
    description = "abcm2ps is a command line program which converts ABC to music sheet in PostScript or SVG format";
    maintainers = [ maintainers.dotlambda ];
  };
}
