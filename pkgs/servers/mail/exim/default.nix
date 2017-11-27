{ coreutils, fetchurl, db, openssl, pcre, perl, pkgconfig, stdenv, fetchpatch }:

stdenv.mkDerivation rec {
  name = "exim-4.89";

  src = fetchurl {
    url = "http://ftp.exim.org/pub/exim/exim4/${name}.tar.xz";
    sha256 = "09lndv34jsxwglq5zsh9y4xaqj5g37g9ca4x0zb25fvvm4f0lj8c";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-1000369.patch";
      url = "https://anonscm.debian.org/git/pkg-exim4/exim4.git/plain/debian/patches/79_CVE-2017-1000369.patch?h=4.89-2%2bdeb9u1";
      sha256 = "0v46zywgkv1rdqhybqqrd0rwkdaj6q1f4x0a3vm9p0wz8vad3023";
    })
    ./cve-2017-16943.patch
  ];

  buildInputs = [ coreutils db openssl pcre perl pkgconfig ];

  preBuild = ''
    sed '
      s:^\(BIN_DIRECTORY\)=.*:\1='"$out"'/bin:
      s:^\(CONFIGURE_FILE\)=.*:\1=/etc/exim.conf:
      s:^\(EXIM_USER\)=.*:\1=ref\:nobody:
      s:^\(SPOOL_DIRECTORY\)=.*:\1=/exim-homeless-shelter:
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
