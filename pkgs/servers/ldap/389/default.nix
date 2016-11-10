{ stdenv, fetchurl, fetchpatch, pkgconfig, perl, pam, nspr, nss, openldap
, db, cyrus_sasl, svrcore, icu, net_snmp, kerberos, pcre, perlPackages
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

  patches = [ ./perl-path.patch
    # https://fedorahosted.org/389/ticket/48354
    (fetchpatch {
      name = "389-ds-base-CVE-2016-5416.patch";
      url = "https://fedorahosted.org/389/changeset/3c2cd48b7d2cb0579f7de6d460bcd0c9bb1157bd/?format=diff&new=3c2cd48b7d2cb0579f7de6d460bcd0c9bb1157bd";
      addPrefixes = true;
      sha256 = "1kv3a3di1cihkaf8xdbb5mzvhm4c3frx8rc5mji8xgjyj9ni6xja";
    })
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
    "--with-db=${db}"
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
    homepage = https://directory.fedoraproject.org/;
    description = "Enterprise-class Open Source LDAP server for Linux";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
