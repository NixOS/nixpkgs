{ stdenv, fetchurl, autoreconfHook, file, openssl, perl, unzip }:

stdenv.mkDerivation rec {
  name = "net-snmp-5.7.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/${name}.zip";
    sha256 = "1nj3b2x4fhsh82nra99128vqp2lfw5wx91ka8nqwzxvik59hb4dc";
  };

  preConfigure =
    ''
      perlversion=$(perl -e 'use Config; print $Config{version};')
      perlarchname=$(perl -e 'use Config; print $Config{archname};')
      installFlags="INSTALLSITEARCH=$out/lib/perl5/site_perl/$perlversion/$perlarchname INSTALLSITEMAN3DIR=$out/share/man/man3"

      # http://comments.gmane.org/gmane.network.net-snmp.user/32434
      substituteInPlace "man/Makefile.in" --replace 'grep -vE' '@EGREP@ -v'
    '';

  configureFlags =
    [ "--with-default-snmp-version=3"
      "--with-sys-location=Unknown"
      "--with-sys-contact=root@unknown"
      "--with-logfile=/var/log/net-snmpd.log"
      "--with-persistent-directory=/var/lib/net-snmp"
    ];

  buildInputs = [ autoreconfHook file openssl perl unzip ];

  enableParallelBuilding = true;

  meta = {
    description = "Clients and server for the SNMP network monitoring protocol";
    homepage = http://net-snmp.sourceforge.net/;
    license = "bsd";
  };
}
