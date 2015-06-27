{ stdenv, fetchurl, openssl, net_snmp }:

stdenv.mkDerivation rec {
  name = "keepalived-1.2.17";

  src = fetchurl {
    url = "http://keepalived.org/software/${name}.tar.gz";
    sha256 = "1w7px8phx3pyb3b56m3nz1a9ncx26q34fgy8j4n2dpi284jmqm6z";
  };

  buildInputs = [ openssl net_snmp ];

  postPatch = ''
    sed -i 's,$(DESTDIR)/usr/share,$out/share,g' Makefile.in
  '';

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
