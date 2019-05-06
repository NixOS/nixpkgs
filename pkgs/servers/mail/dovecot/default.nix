{ stdenv, lib, fetchurl, fetchpatch, perl, pkgconfig, systemd, openssl
, bzip2, zlib, lz4, inotify-tools, pam, libcap
, clucene_core_2, icu, openldap, libsodium, libstemmer, cyrus_sasl
, nixosTests
# Auth modules
, withMySQL ? false, mysql
, withPgSQL ? false, postgresql
, withSQLite ? true, sqlite
}:

stdenv.mkDerivation rec {
  name = "dovecot-2.3.5.2";

  nativeBuildInputs = [ perl pkgconfig ];
  buildInputs =
    [ openssl bzip2 zlib lz4 clucene_core_2 icu openldap libsodium libstemmer cyrus_sasl.dev ]
    ++ lib.optionals (stdenv.isLinux) [ systemd pam libcap inotify-tools ]
    ++ lib.optional withMySQL mysql.connector-c
    ++ lib.optional withPgSQL postgresql
    ++ lib.optional withSQLite sqlite;

  src = fetchurl {
    url = "https://dovecot.org/releases/2.3/${name}.tar.gz";
    sha256 = "1whvyg087sjhkd8r0xnk4ij105j135acnfxq6n58c6nqxwdf855s";
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

    (fetchpatch {
      name = "CVE-2019-11494.patch";
      url = https://github.com/dovecot/core/commit/f79745dae4a9a5fca33320e03a4fc9064b88d01e.patch;
      sha256 = "0qyhcw8xsnjhk7s29mhsqa46m28r2bcjz7bxbjr48d7wl9r3v3fm";
    })
    (fetchpatch {
      name = "CVE-2019-11499.patch";
      url = https://github.com/dovecot/core/commit/e9d60648abb9bbceff89882a5309cb9532e702e9.patch;
      sha256 = "1di6adkd8f6gjkpf8aiqxzwvscsq188qqah6b7r23q9j3zlv47mv";
    })

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
