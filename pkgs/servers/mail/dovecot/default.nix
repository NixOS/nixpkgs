{ stdenv, lib, fetchurl, perl, pkgconfig, systemd, openssl
, bzip2, zlib, lz4, inotify-tools, pam, libcap
, clucene_core_2, icu, openldap, libsodium, libstemmer, cyrus_sasl
, nixosTests
# Auth modules
, withMySQL ? false, mysql
, withPgSQL ? false, postgresql
, withSQLite ? true, sqlite
}:

stdenv.mkDerivation rec {
  name = "dovecot-2.3.6";

  nativeBuildInputs = [ perl pkgconfig ];
  buildInputs =
    [ openssl bzip2 zlib lz4 clucene_core_2 icu openldap libsodium libstemmer cyrus_sasl.dev ]
    ++ lib.optionals (stdenv.isLinux) [ systemd pam libcap inotify-tools ]
    ++ lib.optional withMySQL mysql.connector-c
    ++ lib.optional withPgSQL postgresql
    ++ lib.optional withSQLite sqlite;

  src = fetchurl {
    url = "https://dovecot.org/releases/2.3/${name}.tar.gz";
    sha256 = "1irnalplb47nlc26dn7zzdi95zhrxxi3miza7p3wdsgapv0qs7gd";
  };

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs src/config/settings-get.pl
  '';

  # We need this for sysconfdir, see remark below.
  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    cp -r $out/$out/* $out
    rm -rf $out/$(echo "$out" | cut -d "/" -f2)
  '';

  patches = [
    # Make dovecot look for plugins in /etc/dovecot/modules
    # so we can symlink plugins from several packages there.
    # The symlinking needs to be done in NixOS.
    ./2.2.x-module_dir.patch
  ];

  configureFlags = [
    # It will hardcode this for /var/lib/dovecot.
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=626211
    "--localstatedir=/var"
    # We need this so utilities default to reading /etc/dovecot/dovecot.conf file.
    "--sysconfdir=/etc"
    "--with-ldap"
    "--with-ssl=openssl"
    "--with-zlib"
    "--with-bzlib"
    "--with-lz4"
    "--with-ldap"
    "--with-lucene"
    "--with-icu"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "i_cv_epoll_works=${if stdenv.isLinux then "yes" else "no"}"
    "i_cv_posix_fallocate_works=${if stdenv.isDarwin then "no" else "yes"}"
    "i_cv_inotify_works=${if stdenv.isLinux then "yes" else "no"}"
    "i_cv_signed_size_t=no"
    "i_cv_signed_time_t=yes"
    "i_cv_c99_vsnprintf=yes"
    "lib_cv_va_copy=yes"
    "i_cv_mmap_plays_with_write=yes"
    "i_cv_gmtime_max_time_t=${toString stdenv.hostPlatform.parsed.cpu.bits}"
    "i_cv_signed_time_t=yes"
    "i_cv_fd_passing=yes"
    "lib_cv_va_copy=yes"
    "lib_cv___va_copy=yes"
    "lib_cv_va_val_copy=yes"
  ] ++ lib.optional (stdenv.isLinux) "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ++ lib.optional (stdenv.isDarwin) "--enable-static"
    ++ lib.optional withMySQL "--with-mysql"
    ++ lib.optional withPgSQL "--with-pgsql"
    ++ lib.optional withSQLite "--with-sqlite";

  meta = {
    homepage = https://dovecot.org/;
    description = "Open source IMAP and POP3 email server written with security primarily in mind";
    maintainers = with stdenv.lib.maintainers; [ peti rickynils fpletz ];
    platforms = stdenv.lib.platforms.unix;
  };
  passthru.tests = {
    opensmtpd-interaction = nixosTests.opensmtpd;
  };
}
