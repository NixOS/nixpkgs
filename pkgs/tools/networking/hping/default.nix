{ stdenv, fetchurl, libpcap, tcl }:

stdenv.mkDerivation rec {
  name = "hping-${version}";
  version = "20051105";

  src = fetchurl {
    url = "http://www.hping.org/hping3-${version}.tar.gz";
    sha256 = "1s5f9xd1msx05ibhwaw37jmc7l9fahcxxslqz8a83p0i5ak739pm";
  };

  buildInputs = [ libpcap tcl ];

  configurePhase = ''
    MANPATH="$out/share/man" ./configure
    sed -i -r -e 's|/usr(/s?bin)|'"$out"'\1|g' Makefile
  '';

  TCLSH = "${tcl}/bin/tclsh";

  prePatch = ''
    sed -i -e '/#if.*defined(__i386__)/a \
      || defined(__x86_64__) \\
    ' bytesex.h

    sed -i -e 's|#include.*net/bpf.h|#include <pcap/bpf.h>|' \
      libpcap_stuff.c script.c

    sed -i -r -e 's|"(/usr/(local/)?)?bin/"|"${tcl}/bin"|g' \
              -e 's!/usr/(local/)?(lib|include)!${tcl}/\2!g' \
              configure
  '';

  preInstall = ''
    mkdir -vp "$out/sbin" "$out/share/man/man8"
  '';

  postInstall = ''
    ln -vs hping3.8.gz "$out/share/man/man8/hping.8.gz"
    ln -vs hping3.8.gz "$out/share/man/man8/hping2.8.gz"
  '';

  meta = with stdenv.lib; {
    description = "A command-line oriented TCP/IP packet assembler/analyzer";
    homepage = http://www.hping.org/;
    license = licenses.gpl2;
    platforms = platforms.all;
    broken = stdenv.isDarwin;
  };
}
