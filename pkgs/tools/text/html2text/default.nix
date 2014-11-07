{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "html2text-1.3.2a";

  src = fetchurl {
    url = http://www.mbayer.de/html2text/downloads/html2text-1.3.2a.tar.gz;
    sha256 = "000b39d5d910b867ff7e087177b470a1e26e2819920dcffd5991c33f6d480392";
  };

  preConfigure = ''
    sed -i s,/bin/echo,echo, configure
  '';

  # the --prefix has no effect
  installPhase = ''
    mkdir -p $out/bin $out/man/man{1,5}
    cp html2text $out/bin
    cp html2text.1.gz $out/man/man1
    cp html2textrc.5.gz $out/man/man5
  '';

  meta = {
    description = "html2text is a command line utility, written in C++, that converts HTML documents into plain text.";
    homepage = http://www.mbayer.de/html2text/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eikek ];
  };
}
