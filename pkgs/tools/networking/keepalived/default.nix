{ stdenv, fetchurl, openssl, net_snmp, libnl }:

stdenv.mkDerivation rec {
  name = "keepalived-1.2.17";

  src = fetchurl {
    url = "http://keepalived.org/software/${name}.tar.gz";
    sha256 = "1w7px8phx3pyb3b56m3nz1a9ncx26q34fgy8j4n2dpi284jmqm6z";
  };

  buildInputs = [ openssl net_snmp libnl ];

  # Remove in 1.2.18
  patches = [ ./fix-ip-release.patch ];

  postPatch = ''
    sed -i 's,$(DESTDIR)/usr/share,$out/share,g' Makefile.in
  '';

  # It doesn't know about the include/libnl<n> directory
  NIX_CFLAGS_COMPILE="-I${libnl}/include/libnl3";
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
    description = "routing software written in C";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
