{ stdenv
, autoreconfHook
, fetchFromGitHub
, lib

, bzip2
, cmocka
, cracklib
, cyrus_sasl
, db
, doxygen
, icu
, libevent
, libkrb5
, lm_sensors
, net-snmp
, nspr
, nss
, openldap
, openssl
, pcre
, perl
, perlPackages
, pkg-config
, python3
, svrcore
, zlib

, enablePamPassthru ? true
, pam

, enableCockpit ? true
, rsync

, enableDna ? true
, enableLdapi ? true
, enableAutobind ? false
, enableAutoDnSuffix ? false
, enableBitwise ? true
, enableAcctPolicy ? true
, enablePosixWinsync ? true
}:

stdenv.mkDerivation rec {
  pname = "389-ds-base";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "389ds";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-aM1qo+yHrCFespPWHv2f25ooqQVCIZGaZS43dY6kiC4=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config doxygen ];

  buildInputs = [
    bzip2
    cracklib
    cyrus_sasl
    db
    icu
    libevent
    libkrb5
    lm_sensors
    net-snmp
    nspr
    nss
    openldap
    openssl
    pcre
    perl
    python3
    svrcore
    zlib

    # tests
    cmocka
    libevent

    # lib389
    (python3.withPackages (ps: with ps; [
      setuptools
      ldap
      six
      pyasn1
      pyasn1-modules
      python-dateutil
      argcomplete
      libselinux
    ]))

    # logconv.pl
    perlPackages.DBFile
    perlPackages.ArchiveTar
  ]
  ++ lib.optional enableCockpit rsync
  ++ lib.optional enablePamPassthru pam;

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace 's,@perlpath\@,$(perldir),g' 's,@perlpath\@,$(perldir) $(PERLPATH),g'

    patchShebangs ./buildnum.py ./ldap/servers/slapd/mkDBErrStrs.py
  '';

  preConfigure = ''
    # Create perl paths for library imports in perl scripts
    PERLPATH=""
    for P in $(echo $PERL5LIB | sed 's/:/ /g'); do
      PERLPATH="$PERLPATH $(echo $P/*/*)"
    done
    export PERLPATH
  '';

  configureFlags =
    let
      mkEnable = cond: name: if cond then "--enable-${name}" else "--disable-${name}";
    in
    [
      "--enable-cmocka"
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--with-db-inc=${db.dev}/include"
      "--with-db-lib=${db.out}/lib"
      "--with-db=yes"
      "--with-netsnmp-inc=${lib.getDev net-snmp}/include"
      "--with-netsnmp-lib=${lib.getLib net-snmp}/lib"
      "--with-netsnmp=yes"
      "--with-openldap"

      "${mkEnable enableCockpit "cockpit"}"
      "${mkEnable enablePamPassthru "pam-passthru"}"
      "${mkEnable enableDna "dna"}"
      "${mkEnable enableLdapi "ldapi"}"
      "${mkEnable enableAutobind "autobind"}"
      "${mkEnable enableAutoDnSuffix "auto-dn-suffix"}"
      "${mkEnable enableBitwise "bitwise"}"
      "${mkEnable enableAcctPolicy "acctpolicy"}"
      "${mkEnable enablePosixWinsync "posix-winsync"}"
    ];

  enableParallelBuilding = true;

  doCheck = true;

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=${placeholder "TMPDIR"}"
  ];

  passthru.version = version;

  meta = with lib; {
    homepage = "https://www.port389.org/";
    description = "Enterprise-class Open Source LDAP server for Linux";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
