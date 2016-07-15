{ stdenv, fetchurl, openssl, net_snmp, libnl }:

stdenv.mkDerivation rec {
  name = "keepalived-1.2.19";

  src = fetchurl {
    url = "http://keepalived.org/software/${name}.tar.gz";
    sha256 = "0lrq963pxhgh74qmxjyy5hvxdfpm4r50v4vsrp559n0w5irsxyrj";
  };

  buildInputs = [ openssl net_snmp libnl ];

  postPatch = ''
    sed -i 's,$(DESTDIR)/usr/share,$out/share,g' Makefile.in
  '';

  # It doesn't know about the include/libnl<n> directory
  NIX_CFLAGS_COMPILE="-I${libnl.dev}/include/libnl3";
  NIX_LDFLAGS="-lnl-3 -lnl-genl-3";

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--enable-snmp"
    "--enable-sha1"
  ];

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  meta = with stdenv.lib; {
    homepage = http://keepalived.org;
    description = "Routing software written in C";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
