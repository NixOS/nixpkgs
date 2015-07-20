{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pax-utils-${version}";
  version = "1.0.4";

  src = fetchurl {
    url = "http://dev.gentoo.org/~vapier/dist/${name}.tar.xz";
    sha256 = "1wymfsir2s22zqjdwnwv7bn075vzzlhssgwxnkz33i2d5pr6rqgp";
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
