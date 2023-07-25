{ coreutils, db, fetchurl, openssl, pcre2, perl, pkg-config, lib, stdenv
, enableLDAP ? false, openldap
, enableMySQL ? false, libmysqlclient, zlib
, enableAuthDovecot ? false, dovecot
, enablePAM ? false, pam
, enableSPF ? true, libspf2
, enableDMARC ? true, opendmarc
, enableRedis ? false, hiredis
}:

stdenv.mkDerivation rec {
  pname = "exim";
  version = "4.96";

  src = fetchurl {
    url = "https://ftp.exim.org/pub/exim/exim4/${pname}-${version}.tar.xz";
    hash = "sha256-KZpWknsus0d9qv08W9oCvGflxOWJinrq8nQIdSeM8aM=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ coreutils db openssl perl pcre2 ]
    ++ lib.optional enableLDAP openldap
    ++ lib.optionals enableMySQL [ libmysqlclient zlib ]
    ++ lib.optional enableAuthDovecot dovecot
    ++ lib.optional enablePAM pam
    ++ lib.optional enableSPF libspf2
    ++ lib.optional enableDMARC opendmarc
    ++ lib.optional enableRedis hiredis;

  configurePhase = ''
    runHook preConfigure

    sed '
      s:^\(BIN_DIRECTORY\)=.*:\1='"$out"'/bin:
      s:^\(CONFIGURE_FILE\)=.*:\1=/etc/exim.conf:
      s:^\(EXIM_USER\)=.*:\1=ref\:nobody:
      s:^\(SPOOL_DIRECTORY\)=.*:\1=/exim-homeless-shelter:
      s:^# \(TRANSPORT_LMTP\)=.*:\1=yes:
      s:^# \(SUPPORT_MAILDIR\)=.*:\1=yes:
      s:^EXIM_MONITOR=.*$:# &:
      s:^\(FIXED_NEVER_USERS\)=root$:\1=0:
      s:^# \(WITH_CONTENT_SCAN\)=.*:\1=yes:
      s:^# \(AUTH_PLAINTEXT\)=.*:\1=yes:
      s:^# \(USE_OPENSSL\)=.*:\1=yes:
      s:^# \(USE_OPENSSL_PC=openssl\)$:\1:
      s:^# \(LOG_FILE_PATH=syslog\)$:\1:
      s:^# \(HAVE_IPV6=yes\)$:\1:
      s:^# \(CHOWN_COMMAND\)=.*:\1=${coreutils}/bin/chown:
      s:^# \(CHGRP_COMMAND\)=.*:\1=${coreutils}/bin/chgrp:
      s:^# \(CHMOD_COMMAND\)=.*:\1=${coreutils}/bin/chmod:
      s:^# \(MV_COMMAND\)=.*:\1=${coreutils}/bin/mv:
      s:^# \(RM_COMMAND\)=.*:\1=${coreutils}/bin/rm:
      s:^# \(TOUCH_COMMAND\)=.*:\1=${coreutils}/bin/touch:
      s:^# \(PERL_COMMAND\)=.*:\1=${perl}/bin/perl:
      s:^# \(LOOKUP_DSEARCH=yes\)$:\1:
      ${lib.optionalString enableLDAP ''
        s:^# \(LDAP_LIB_TYPE=OPENLDAP2\)$:\1:
        s:^# \(LOOKUP_LDAP=yes\)$:\1:
        s:^\(LOOKUP_LIBS\)=\(.*\):\1=\2 -lldap -llber:
        s:^# \(LOOKUP_LIBS\)=.*:\1=-lldap -llber:
      ''}
      ${lib.optionalString enableMySQL ''
        s:^# \(LOOKUP_MYSQL=yes\)$:\1:
        s:^# \(LOOKUP_MYSQL_PC=libmysqlclient\)$:\1:
        s:^\(LOOKUP_LIBS\)=\(.*\):\1=\2 -lmysqlclient -L${libmysqlclient}/lib/mysql -lssl -lm -lpthread -lz:
        s:^# \(LOOKUP_LIBS\)=.*:\1=-lmysqlclient -L${libmysqlclient}/lib/mysql -lssl -lm -lpthread -lz:
        s:^# \(LOOKUP_INCLUDE\)=.*:\1=-I${libmysqlclient.dev}/include/mysql/:
      ''}
      ${lib.optionalString enableAuthDovecot ''
        s:^# \(AUTH_DOVECOT\)=.*:\1=yes:
      ''}
      ${lib.optionalString enablePAM ''
        s:^# \(SUPPORT_PAM\)=.*:\1=yes:
        s:^\(EXTRALIBS_EXIM\)=\(.*\):\1=\2 -lpam:
        s:^# \(EXTRALIBS_EXIM\)=.*:\1=-lpam:
      ''}
      ${lib.optionalString enableSPF ''
        s:^# \(SUPPORT_SPF\)=.*:\1=yes:
        s:^# \(LDFLAGS += -lspf2\):\1:
      ''}
      ${lib.optionalString enableDMARC ''
        s:^# \(SUPPORT_DMARC\)=.*:\1=yes:
        s:^# \(LDFLAGS += -lopendmarc\):\1:
      ''}
      ${lib.optionalString enableRedis ''
        s:^# \(LOOKUP_REDIS=yes\)$:\1:
        s:^\(LOOKUP_LIBS\)=\(.*\):\1=\2 -lhiredis -L${hiredis}/lib/hiredis:
        s:^# \(LOOKUP_LIBS\)=.*:\1=-lhiredis -L${hiredis}/lib/hiredis:
        s:^\(LOOKUP_INCLUDE\)=\(.*\):\1=\2 -I${hiredis}/include/hiredis/:
        s:^# \(LOOKUP_INCLUDE\)=.*:\1=-I${hiredis}/include/hiredis/:
      ''}
      #/^\s*#.*/d
      #/^\s*$/d
    ' < src/EDITME > Local/Makefile

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/man/man8
    cp doc/exim.8 $out/share/man/man8

    ( cd build-Linux-*
      cp exicyclog exim_checkaccess exim_dumpdb exim_lock exim_tidydb \
        exipick exiqsumm exigrep exim_dbmbuild exim exim_fixdb eximstats \
        exinext exiqgrep exiwhat \
        $out/bin )

    ( cd $out/bin
      for i in mailq newaliases rmail rsmtp runq sendmail; do
        ln -s exim $i
      done )

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://exim.org/";
    description = "A mail transfer agent (MTA)";
    license = with licenses; [ gpl2Plus bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tv ajs124 das_j ];
    changelog = "https://github.com/Exim/exim/blob/exim-${version}/doc/doc-txt/ChangeLog";
  };
}
