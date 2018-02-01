{ stdenv, lib, fetchurl, fetchpatch, perl, pkgconfig, systemd, openssl
, bzip2, zlib, inotify-tools, pam, libcap
, clucene_core_2, icu, openldap
# Auth modules
, withMySQL ? false, libmysql
, withPgSQL ? false, postgresql
, withSQLite ? true, sqlite
}:

stdenv.mkDerivation rec {
  name = "dovecot-2.2.33.2";

  nativeBuildInputs = [ perl pkgconfig ];
  buildInputs = [ openssl bzip2 zlib clucene_core_2 icu openldap ]
    ++ lib.optionals (stdenv.isLinux) [ systemd pam libcap inotify-tools ]
    ++ lib.optional withMySQL libmysql
    ++ lib.optional withPgSQL postgresql
    ++ lib.optional withSQLite sqlite;

  src = fetchurl {
    url = "http://dovecot.org/releases/2.2/${name}.tar.gz";
    sha256 = "117f9i62liz2pm96zi2lpldzlj2knzj7g410zhifwmlsc1w3n7py";
  };

  preConfigure = ''
    patchShebangs src/config/settings-get.pl
  '';

  # We need this for sysconfdir, see remark below.
  installFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    cp -r $out/$out/* $out
    rm -rf $out/$(echo "$out" | cut -d "/" -f2)
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -change libclucene-shared.1.dylib \
        ${clucene_core_2}/lib/libclucene-shared.1.dylib \
        $out/lib/dovecot/lib21_fts_lucene_plugin.so
    install_name_tool -change libclucene-core.1.dylib \
        ${clucene_core_2}/lib/libclucene-core.1.dylib \
        $out/lib/dovecot/lib21_fts_lucene_plugin.so
  '';

  patches = [
    # Make dovecot look for plugins in /etc/dovecot/modules
    # so we can symlink plugins from several packages there.
    # The symlinking needs to be done in NixOS.
    ./2.2.x-module_dir.patch
    (fetchpatch {
      name = "CVE-2017-14132_part1.patch";
      url = https://github.com/dovecot/core/commit/1a29ed2f96da1be22fa5a4d96c7583aa81b8b060.patch;
      sha256 = "1pcfzxr8xlwbpa7z19grp7mlvdnan6ln8zw74dj4pdmynmlk4aw9";
    })
    (fetchpatch {
      name = "CVE-2017-14132_part2.patch";
      url = https://github.com/dovecot/core/commit/a9b135760aea6d1790d447d351c56b78889dac22.patch;
      sha256 = "0082iid5rvjmh003xi9s09jld2rb31hbvni0yai1h1ggbmd5zf8l";
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
    "--with-ldap"
    "--with-lucene"
    "--with-icu"
  ] ++ lib.optional (stdenv.isLinux) "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ++ lib.optional (stdenv.isDarwin) "--enable-static"
    ++ lib.optional withMySQL "--with-mysql"
    ++ lib.optional withPgSQL "--with-pgsql"
    ++ lib.optional withSQLite "--with-sqlite";

  meta = {
    homepage = http://dovecot.org/;
    description = "Open source IMAP and POP3 email server written with security primarily in mind";
    maintainers = with stdenv.lib.maintainers; [viric peti rickynils];
    platforms = stdenv.lib.platforms.unix;
  };
}
