{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, cairo, gtk, poppler }:

stdenv.mkDerivation rec {
  name = "pdf2svg-${version}";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "db9052";
    repo = "pdf2svg";
    rev = "v${version}";
    sha256 = "14ffdm4y26imq99wjhkrhy9lp33165xci1l5ndwfia8hz53bl02k";
  };

  buildInputs = [ autoreconfHook cairo pkgconfig poppler gtk ];

  meta = with stdenv.lib; {
    description = "PDF converter to SVG format";
    homepage = http://www.cityinthesky.co.uk/opensource/pdf2svg;
    license = licenses.gpl2;
    maintainers = [ maintainers.ianwookim ];
    platforms = platforms.unix;
  };
}
