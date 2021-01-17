{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoreconfHook
, pkg-config
, doxygen
, perl
, pam
, nspr
, nss
, openldap
, db
, cyrus_sasl
, svrcore
, icu
, net-snmp
, kerberos
, pcre
, perlPackages
, libevent
, openssl
, python
, cracklib
, rsync
}:

stdenv.mkDerivation rec {
  pname = "389-ds-base";
  version = "1.4.4.13";

  src = fetchFromGitHub {
    owner = "389ds";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1zasnw5idjyd6in22bfdz20cyiqnwx0lss8shf53aib92jxm1504";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    doxygen
    rsync
  ];

  buildInputs = [
    perl
    pam
    nspr
    nss
    openldap
    db
    cyrus_sasl
    svrcore
    icu
    net-snmp
    kerberos
    pcre
    libevent
    openssl
    python
    cracklib
  ] ++ (with perlPackages; [
    MozillaLdap
    NetAddrIP
    DBFile
  ]);

  patches = [
    # This reverts a commit that adds support for the gost-yescrypt password hashing algorithm,
    # since it requires a glibc with patches for blowfish/bcrypt support to build
    (fetchpatch {
      url = "https://github.com/389ds/389-ds-base/commit/bf46ccec94da41616b7fa1bd5ac39c970b367846.patch";
      revert = true;
      sha256 = "16i91gvlj0cxz520bbfl45pr0rvgdh6mz2rw62pr688q7id9gs4g";
    })
  ];

  postPatch = ''
    patchShebangs .
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
    "--with-netsnmp-inc=${lib.getDev net-snmp}/include"
    "--with-netsnmp-lib=${lib.getLib net-snmp}/lib"
    "--with-journald"
    "--enable-autobind"
    "--enable-perl"
  ];

  enableParallelBuilding = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=${placeholder "TMPDIR"}"
  ];

  meta = with lib; {
    homepage = "https://www.port389.org/";
    description = "Enterprise-class Open Source LDAP server for Linux";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
