{ stdenv, fetchurl, wxGTK29, boost }:

stdenv.mkDerivation rec {
  name = "poedit-1.5.7";

  src = fetchurl {
    url = "mirror://sourceforge/poedit/${name}.tar.gz";
    sha256 = "0y0gbkb1jvp61qhh8sh7ar8849mwirizc42pk57zpxy84an5qlr4";
  };

  buildInputs = [ wxGTK29 boost ];

  meta = with stdenv.lib; {
    description = "Cross-platform gettext catalogs (.po files) editor";
    homepage = http://www.poedit.net/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ domenkozar ];
  };
}
