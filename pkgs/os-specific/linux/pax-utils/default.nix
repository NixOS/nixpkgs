{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pax-utils-${version}";
  version = "1.1.6";

  src = fetchurl {
    url = "https://dev.gentoo.org/~vapier/dist/${name}.tar.xz";
    sha256 = "04hvsizzspfzfq6hhfif7ya9nwsc0cs6z6n2bq1zfh7agd8nqhzm";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "A suite of tools for PaX/grsecurity";
    homepage    = "https://dev.gentoo.org/~vapier/dist/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
