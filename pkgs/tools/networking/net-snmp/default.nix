{ stdenv, fetchurl, file, openssl }:

stdenv.mkDerivation rec {
  name = "net-snmp-5.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/${name}.tar.gz";
    sha256 = "07qqdgs3flraqccwry4a4x23jcg6vfi0rqj7clsibdv51ijwjwbw";
  };

  configureFlags =
    [ "--with-default-snmp-version=3"
      "--with-sys-location=Unknown"
      "--with-sys-contact=root@unknown"
      "--with-logfile=/var/log/net-snmpd.log"
      "--with-persistent-directory=/var/lib/net-snmp"
    ];

  buildInputs = [ file openssl ];

  enableParallelBuilding = true;

  meta = {
    description = "Clients and server for the SNMP network monitoring protocol";
    homepage = http://net-snmp.sourceforge.net/;
    license = "bsd";
  };
}
