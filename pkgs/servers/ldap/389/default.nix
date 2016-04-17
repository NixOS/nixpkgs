{ stdenv, fetchurl, pkgconfig, perl, pam, nspr, nss, openldap, db, cyrus_sasl
, svrcore, icu, net_snmp, kerberos, pcre, perlPackages
}:
let
  version = "1.3.3.9";
in
stdenv.mkDerivation rec {
  name = "389-ds-base-${version}";

  src = fetchurl {
    url = "http://directory.fedoraproject.org/binaries/${name}.tar.bz2";
    sha256 = "1qqwv5j60f38hz4xpbzn4pixhkj07yjzbp7kz7cvfkgvdwy9jqxx";
  };

  buildInputs = [
    pkgconfig perl pam nspr nss openldap db cyrus_sasl svrcore icu
    net_snmp kerberos pcre
  ] ++ (with perlPackages; [ MozillaLdap NetAddrIP DBFile ]);

  # TODO: Fix bin/ds-logpipe.py, bin/logconv, bin/cl-dump

  patches = [ ./perl-path.patch ];

  preConfigure = ''
    # Create perl paths for library imports in perl scripts
    PERLPATH=""
    for P in $(echo $PERL5LIB | sed 's/:/ /g'); do
      PERLPATH="$PERLPATH $(echo $P/*/*)"
    done
    export PERLPATH
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-openldap"
    "--with-db=${db}"
    "--with-sasl=${cyrus_sasl}"
    "--with-netsnmp=${net_snmp}"
  ];
  
  preInstall = ''
    # The makefile doesn't create this directory for whatever reason
    mkdir -p $out/lib/dirsrv
  '';

  installFlags = [
    "sysconfdir=\${out}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  passthru.version = version;

  meta = with stdenv.lib; {
    homepage = https://directory.fedoraproject.org/;
    description = "enterprise-class Open Source LDAP server for Linux";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
