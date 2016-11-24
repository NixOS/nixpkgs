{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pax-utils-${version}";
  version = "1.1.7";

  src = fetchurl {
    url = "https://dev.gentoo.org/~vapier/dist/${name}.tar.xz";
    sha256 = "045dxgl4kkmq6205iw6fqyx3565gd607p3xpad5l9scdi3qdp6xv";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    description = "A suite of tools for PaX/grsecurity";
    homepage    = "https://dev.gentoo.org/~vapier/dist/";
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice joachifm ];
  };
}
