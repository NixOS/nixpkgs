{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "p910nd-${version}";
  version = "0.97";

  src = fetchurl {
    sha256 = "0vy2qf386dif1nqznmy3j953mq7c4lk6j2hgyzkbmfi4msiq1jaa";
    url = "mirror://sourceforge/p910nd/${name}.tar.bz2";
  };

  postPatch = ''
    sed -e "s|/usr||g" -i Makefile
  '';

  makeFlags = [ "DESTDIR=$(out)" "BINDIR=/bin" ];

  postInstall = ''
    # Match the man page:
    mv $out/etc/init.d/p910nd{,.sh}

    # The legacy init script is useful only (and even then...) as an example:
    mkdir -p $out/share/doc/examples
    mv $out/etc $out/share/doc/examples
  '';

  meta = with stdenv.lib; {
    description = "Small printer daemon passing jobs directly to the printer";
    longDescription = ''
      p910nd is a small printer daemon intended for diskless platforms that
      does not spool to disk but passes the job directly to the printer.
      Normally a lpr daemon on a spooling host connects to it with a TCP
      connection on port 910n (where n=0, 1, or 2 for lp0, 1 and 2
      respectively). p910nd is particularly useful for diskless platforms.
      Common Unix Printing System (CUPS) supports this protocol, it's called
      the AppSocket protocol and has the scheme socket://. LPRng also supports
      this protocol and the syntax is lp=remotehost%9100 in /etc/printcap.
    '';
    homepage = http://p910nd.sourceforge.net/;
    downloadPage = https://sourceforge.net/projects/p910nd/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
