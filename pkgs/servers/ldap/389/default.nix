{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig, doxygen, perl, pam, nspr, nss, openldap
, db, cyrus_sasl, svrcore, icu, net-snmp, kerberos, pcre, perlPackages, libevent, openssl, python
}:

stdenv.mkDerivation rec {
  pname = "389-ds-base";
  version = "1.3.9.1";

  src = fetchurl {
    url = "https://releases.pagure.org/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "141iv1phgk1lw74sfjj3v7wy6qs0q56lvclwv2p0hqn1wg8ic4q6";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig doxygen ];
  buildInputs = [
    perl pam nspr nss openldap db cyrus_sasl svrcore icu
    net-snmp kerberos pcre libevent openssl python
  ] ++ (with perlPackages; [ MozillaLdap NetAddrIP DBFile ]);

  patches = [
    (fetchpatch {
      name = "389-ds-nss.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/nss.patch?h=389-ds-base&id=b80ed52cc65ff9b1d72f8ebc54dbd462b12f6be9";
      sha256 = "07z7jl9z4gzhk3k6qyfn558xl76js8041llyr5n99h20ckkbwagk";
    })
  ];
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace 's,@perlpath\@,$(perldir),g' 's,@perlpath\@,$(perldir) $(PERLPATH),g'
  '';

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
    "--with-netsnmp=yes"
    "--with-netsnmp-inc=${stdenv.lib.getDev net-snmp}/include"
    "--with-netsnmp-lib=${stdenv.lib.getLib net-snmp}/lib"
  ];

  enableParallelBuilding = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=${placeholder "TMPDIR"}"
  ];

  passthru.version = version;

  meta = with stdenv.lib; {
    homepage = "https://www.port389.org/";
    description = "Enterprise-class Open Source LDAP server for Linux";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
