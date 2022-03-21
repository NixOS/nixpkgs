{ stdenv, lib, fetchurl, perl, pkg-config, systemd, openssl
, bzip2, zlib, lz4, inotify-tools, pam, libcap, coreutils
, clucene_core_2, icu, openldap, libsodium, libstemmer, cyrus_sasl
, nixosTests
# Auth modules
, withMySQL ? false, libmysqlclient
, withPgSQL ? false, postgresql
, withSQLite ? true, sqlite
, withLua ? false, lua5_3
}:

stdenv.mkDerivation rec {
  pname = "dovecot";
  version = "2.3.18";

  nativeBuildInputs = [ perl pkg-config ];
  buildInputs =
    [ openssl bzip2 zlib lz4 clucene_core_2 icu openldap libsodium libstemmer cyrus_sasl.dev ]
    ++ lib.optionals (stdenv.isLinux) [ systemd pam libcap inotify-tools ]
    ++ lib.optional withMySQL libmysqlclient
    ++ lib.optional withPgSQL postgresql
    ++ lib.optional withSQLite sqlite
    ++ lib.optional withLua lua5_3;

  src = fetchurl {
    url = "https://dovecot.org/releases/${lib.versions.majorMinor version}/${pname}-${version}.tar.gz";
    hash = "sha256-Buc/ZoxsCTxFve7rfCA5irjcSTFyNPS1eBrF4sxdbDM=";
  };

  enableParallelBuilding = true;

  postPatch = ''
    sed -i -E \
      -e 's!/bin/sh\b!${stdenv.shell}!g' \
      -e 's!([^[:alnum:]/_-])/bin/([[:alnum:]]+)\b!\1${coreutils}/bin/\2!g' \
      -e 's!([^[:alnum:]/_-])(head|sleep|cat)\b!\1${coreutils}/bin/\2!g' \
      src/lib-program-client/test-program-client-local.c

    patchShebangs src/lib-smtp/test-bin/*.sh
    sed -i -s -E 's!\bcat\b!${coreutils}/bin/cat!g' src/lib-smtp/test-bin/*.sh

    patchShebangs src/config/settings-get.pl
  '' + lib.optionalString stdenv.isLinux ''
    export systemdsystemunitdir=$out/etc/systemd/system
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
  ] ++ lib.optional stdenv.isLinux "--with-systemd"
    ++ lib.optional stdenv.isDarwin "--enable-static"
    ++ lib.optional withMySQL "--with-mysql"
    ++ lib.optional withPgSQL "--with-pgsql"
    ++ lib.optional withSQLite "--with-sqlite"
    ++ lib.optional withLua "--with-lua";

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = "https://dovecot.org/";
    description = "Open source IMAP and POP3 email server written with security primarily in mind";
    license = with licenses; [ mit publicDomain lgpl21Only bsd3 bsdOriginal ];
    maintainers = with maintainers; [ fpletz globin ajs124 ];
    platforms = platforms.unix;
  };
  passthru.tests = {
    opensmtpd-interaction = nixosTests.opensmtpd;
    inherit (nixosTests) dovecot;
  };
}
