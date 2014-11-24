{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pax-utils-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "http://dev.gentoo.org/~vapier/dist/${name}.tar.xz";
    sha256 = "1pmlpjhr2475h5v90abmsfgr37r3b6c4mknhzswbgcb10vgh322p";
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
