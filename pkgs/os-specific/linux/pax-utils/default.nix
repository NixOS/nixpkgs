{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pax-utils-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "http://dev.gentoo.org/~vapier/dist/${name}.tar.xz";
    sha256 = "15708pm5l1bgxg1bgic82hqvmn3gcq83mi1l8akhz9qlykh5sfdq";
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
