{ stdenv, fetchurl, autoreconfHook, file, openssl, perl, unzip }:

stdenv.mkDerivation rec {
  name = "net-snmp-5.7.3";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/${name}.zip";
    sha256 = "0gkss3zclm23zwpqfhddca8278id7pk6qx1mydpimdrrcndwgpz8";
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
      "--with-openssl=${openssl.dev}"
    ] ++ stdenv.lib.optional stdenv.isLinux "--with-mnttab=/proc/mounts";

  buildInputs = [ autoreconfHook file perl unzip openssl ];

  enableParallelBuilding = true;

  postInstall = ''
    for f in "$out/lib/"*.la $out/bin/net-snmp-config $out/bin/net-snmp-create-v3-user; do
      sed 's|-L${openssl.dev}|-L${openssl.out}|g' -i $f
    done
  '';

  meta = with stdenv.lib; {
    description = "Clients and server for the SNMP network monitoring protocol";
    homepage = http://net-snmp.sourceforge.net/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
