{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pax-utils-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "https://dev.gentoo.org/~vapier/dist/${name}.tar.xz";
    sha512 = "26f7lqr1s2iywj8qfbf24sm18bl6f7cwsf77nxwwvgij1z88gvh6yx3gp65zap92l0xjdp8kwq9y96xld39p86zd9dmkm447czykbvb";
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
