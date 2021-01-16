{ stdenv, lib, fetchurl, fetchpatch, perl, pkgconfig, systemd, openssl
, bzip2, zlib, lz4, inotify-tools, pam, libcap
, clucene_core_2, icu, openldap, libsodium, libstemmer, cyrus_sasl
, nixosTests
# Auth modules
, withLua ? true, lua, autoreconfHook
, withMySQL ? false, libmysqlclient
, withPgSQL ? false, postgresql
, withSQLite ? true, sqlite
}:

stdenv.mkDerivation rec {
  pname = "dovecot";
  version = "2.3.13";

  # autoreconfHook can be removed as soon as the patch to fix the lua build below is removed
  nativeBuildInputs = [ autoreconfHook perl pkgconfig ];
  buildInputs =
    [ openssl bzip2 zlib lz4 clucene_core_2 icu openldap libsodium libstemmer cyrus_sasl.dev ]
    ++ lib.optionals (stdenv.isLinux) [ systemd pam libcap inotify-tools ]
    ++ lib.optional withMySQL libmysqlclient
    ++ lib.optional withPgSQL postgresql
    ++ lib.optional withSQLite sqlite
    ++ lib.optional withLua lua;

  src = fetchurl {
    url = "https://dovecot.org/releases/2.3/${pname}-${version}.tar.gz";
    sha256 = "1i7ijss79a23v7b6lycfzaa8r5rh01k0h0b9h0j4a6n11sw7by53";
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
    ./2.3.x-module_dir.patch
    # This fixes the build of the lua module, remove when it's included in a relase
    (fetchpatch {
      url = "https://github.com/dovecot/core/commit/2dac24558091c673e5918568d9958f6d8f261fc5.patch";
      sha256 = "05hglw36imq4858055a48j0gnwm85g8z6kdckjghsm69bc97y5n2";
    })
  ];

  configureFlags = [
    # It will hardcode this for /var/lib/dovecot.
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=626211
    "--localstatedir=/var"
    # We need this so utilities default to reading /etc/dovecot/dovecot.conf file.
    "--sysconfdir=/etc"
    "--with-bzlib"
    "--with-icu"
    "--with-ldap"
    "--with-lucene"
    "--with-lz4"
    "--with-ssl=openssl"
    "--with-zlib"
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
    ++ lib.optional withLua "--with-lua"
    ++ lib.optional withMySQL "--with-mysql"
    ++ lib.optional withPgSQL "--with-pgsql"
    ++ lib.optional withSQLite "--with-sqlite";

  meta = {
    homepage = "https://dovecot.org/";
    description = "Open source IMAP and POP3 email server written with security primarily in mind";
    maintainers = with lib.maintainers; [ peti fpletz globin ajs124 ];
    platforms = lib.platforms.unix;
  };
  passthru.tests = {
    opensmtpd-interaction = nixosTests.opensmtpd;
    inherit (nixosTests) dovecot;
  };
}
