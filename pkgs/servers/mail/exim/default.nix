{ coreutils, db, fetchurl, openssl, pcre, perl, pkgconfig, stdenv
, enableLDAP ? false, openldap
, enableMySQL ? false, mysql, zlib
, enableAuthDovecot ? false, dovecot
, enablePAM ? false, pam
}:

stdenv.mkDerivation rec {
  name = "exim-4.92";

  src = fetchurl {
    url = "https://ftp.exim.org/pub/exim/exim4/${name}.tar.xz";
    sha256 = "0qhxxwl0nhzgp0w3pjkhx9z9lqfpk8id25q5ghf9ay2f90mydjba";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ coreutils db openssl perl pcre ]
    ++ stdenv.lib.optional enableLDAP openldap
    ++ stdenv.lib.optionals enableMySQL [ mysql zlib ]
    ++ stdenv.lib.optional enableAuthDovecot dovecot
    ++ stdenv.lib.optional enablePAM pam;

  preBuild = ''
    ${stdenv.lib.optionalString enableMySQL "PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${mysql}/share/mysql/pkgconfig/"}
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
      s:^# \(SUPPORT_TLS\)=.*:\1=yes:
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
        s:^\(LOOKUP_LIBS\)=\(.*\):\1=\2 -lldap:
        s:^# \(LOOKUP_LIBS\)=.*:\1=-lldap:
      ''}
      ${stdenv.lib.optionalString enableMySQL ''
        s:^# \(LOOKUP_MYSQL=yes\)$:\1:
        s:^# \(LOOKUP_MYSQL_PC=mariadb\)$:\1:
        s:^\(LOOKUP_LIBS\)=\(.*\):\1=\2 -lmysqlclient:
        s:^# \(LOOKUP_LIBS\)=.*:\1=-lmysqlclient:
        s:^# \(LOOKUP_INCLUDE\)=.*:\1=-I${mysql}/include/mysql/:
      ''}
      ${stdenv.lib.optionalString enableAuthDovecot ''
        s:^# \(AUTH_DOVECOT\)=.*:\1=yes:
      ''}
      ${stdenv.lib.optionalString enablePAM ''
        s:^# \(SUPPORT_PAM\)=.*:\1=yes:
        s:^\(EXTRALIBS_EXIM\)=\(.*\):\1=\2 -lpam:
        s:^# \(EXTRALIBS_EXIM\)=.*:\1=-lpam:
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

  meta = {
    homepage = http://exim.org/;
    description = "A mail transfer agent (MTA)";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.tv ];
  };
}
