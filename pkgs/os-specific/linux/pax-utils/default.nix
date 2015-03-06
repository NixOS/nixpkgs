{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pax-utils-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "http://dev.gentoo.org/~vapier/dist/${name}.tar.xz";
    sha256 = "0v14dvkg19yabh0ijy8fbrvapxvc36dwhvp90py3baq7qb44wrc7";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "A suite of tools for PaX/grsecurity";
    homepage    = "http://dev.gentoo.org/~vapier/dist/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice wizeman ];
  };
}
