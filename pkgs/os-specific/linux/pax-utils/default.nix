{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "pax-utils-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "http://dev.gentoo.org/~vapier/dist/${name}.tar.xz";
    sha256 = "0gldvyr96jgbcahq7rl3k4krzyhvlz95ckiqh3yhink56s5z58cy";
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
