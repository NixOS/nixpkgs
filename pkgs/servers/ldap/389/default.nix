{ stdenv, fetchurl, pkgconfig, perl, pam, nspr, nss, openldap, db, cyrus_sasl
, svrcore, icu, net_snmp, krb5, pcre
}:

stdenv.mkDerivation rec {
  name = "389-ds-base-1.3.3.5";

  src = fetchurl {
    url = "http://directory.fedoraproject.org/binaries/${name}.tar.bz2";
    sha256 = "09w81salyr56njsvq9p96ijrrs0vwsczd43jf6384ylzj1jrxxl5";
  };

  buildInputs = [
    pkgconfig perl pam nspr nss openldap db cyrus_sasl svrcore icu
    net_snmp krb5 pcre
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-openldap=${openldap}"
    "--with-db=${db}"
    "--with-sasl=${cyrus_sasl}"
    "--with-netsnmp=${net_snmp}"
  ];
  
  meta = with stdenv.lib; {
    homepage = https://directory.fedoraproject.org/;
    description = "enterprise-class Open Source LDAP server for Linux";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
