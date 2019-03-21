{ stdenv, fetchurl, pkgconfig, perl, pam, nspr, nss, openldap
, db, cyrus_sasl, svrcore, icu, net_snmp, kerberos, pcre, perlPackages
}:
let
  version = "1.3.5.19";
in
stdenv.mkDerivation rec {
  name = "389-ds-base-${version}";

  src = fetchurl {
    url = "http://directory.fedoraproject.org/binaries/${name}.tar.bz2";
    sha256 = "1r1n44xfvy51r4r1180dfmjziyj3pqxwmnv6rjvvvjjm87fslmdd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    perl pam nspr nss openldap db cyrus_sasl svrcore icu
    net_snmp kerberos pcre
  ] ++ (with perlPackages; [ MozillaLdap NetAddrIP DBFile ]);

  # TODO: Fix bin/ds-logpipe.py, bin/logconv, bin/cl-dump

  patches = [ ./perl-path.patch
  ];

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
    "--with-db"
    "--with-db-inc=${db.dev}/include"
    "--with-db-lib=${db.out}/lib"
    "--with-sasl=${cyrus_sasl.dev}"
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
    homepage = http://www.port389.org/;
    description = "Enterprise-class Open Source LDAP server for Linux";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
