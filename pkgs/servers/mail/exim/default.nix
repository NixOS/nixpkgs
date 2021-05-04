{ coreutils, db, fetchurl, openssl, pcre, perl, pkgconfig, stdenv
, enableLDAP ? false, openldap
, enableMySQL ? false, libmysqlclient, zlib
, enableAuthDovecot ? false, dovecot
, enablePAM ? false, pam
, enableSPF ? true, libspf2
, enableDMARC ? true, opendmarc
}:

stdenv.mkDerivation rec {
  pname = "exim";
  version = "4.94.2";

  src = fetchurl {
    url = "https://ftp.exim.org/pub/exim/exim4/${pname}-${version}.tar.xz";
    sha256 = "0x4j698gsawm8a3bz531pf1k6izyxfvry4hj5wb0aqphi7y62605";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ coreutils db openssl perl pcre ]
    ++ stdenv.lib.optional enableLDAP openldap
    ++ stdenv.lib.optionals enableMySQL [ libmysqlclient zlib ]
    ++ stdenv.lib.optional enableAuthDovecot dovecot
    ++ stdenv.lib.optional enablePAM pam
    ++ stdenv.lib.optional enableSPF libspf2
    ++ stdenv.lib.optional enableDMARC opendmarc;

  preBuild = ''
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
      ${stdenv.lib.optionalString enableLDAP ''
        s:^# \(LDAP_LIB_TYPE=OPENLDAP2\)$:\1:
        s:^# \(LOOKUP_LDAP=yes\)$:\1:
        s:^\(LOOKUP_LIBS\)=\(.*\):\1=\2 -lldap -llber:
        s:^# \(LOOKUP_LIBS\)=.*:\1=-lldap -llber:
      ''}
      ${stdenv.lib.optionalString enableMySQL ''
        s:^# \(LOOKUP_MYSQL=yes\)$:\1:
        s:^# \(LOOKUP_MYSQL_PC=libmysqlclient\)$:\1:
        s:^\(LOOKUP_LIBS\)=\(.*\):\1=\2 -lmysqlclient -L${libmysqlclient}/lib/mysql -lssl -ldl -lm -lpthread -lz:
        s:^# \(LOOKUP_LIBS\)=.*:\1=-lmysqlclient -L${libmysqlclient}/lib/mysql -lssl -ldl -lm -lpthread -lz:
        s:^# \(LOOKUP_INCLUDE\)=.*:\1=-I${libmysqlclient}/include/mysql/:
      ''}
      ${stdenv.lib.optionalString enableAuthDovecot ''
        s:^# \(AUTH_DOVECOT\)=.*:\1=yes:
      ''}
      ${stdenv.lib.optionalString enablePAM ''
        s:^# \(SUPPORT_PAM\)=.*:\1=yes:
        s:^\(EXTRALIBS_EXIM\)=\(.*\):\1=\2 -lpam:
        s:^# \(EXTRALIBS_EXIM\)=.*:\1=-lpam:
      ''}
      ${stdenv.lib.optionalString enableSPF ''
        s:^# \(SUPPORT_SPF\)=.*:\1=yes:
        s:^# \(LDFLAGS += -lspf2\):\1:
      ''}
      ${stdenv.lib.optionalString enableDMARC ''
        s:^# \(SUPPORT_DMARC\)=.*:\1=yes:
        s:^# \(LDFLAGS += -lopendmarc\):\1:
      ''}
      #/^\s*#.*/d
      #/^\s*$/d
    ' < src/EDITME > Local/Makefile
  '';

  installPhase = ''
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
  '';

  meta = with stdenv.lib; {
    homepage = "http://exim.org/";
    description = "A mail transfer agent (MTA)";
    license = with licenses; [ gpl2Plus bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ tv ajs124 das_j ];
  };
}
