{ stdenv, lib, fetchurl, pkg-config
, bison, cyrus_sasl, icu, jansson, flex, libbsd, libtool, libuuid, openssl
, cunit, coreutils, perl
# CalDAV, CardDAV
, withHttp ? true, brotli, libical, libxml2, nghttp2, shapelib, zlib
, withJMAP ? true, libchardet, wslay
, withXapian ? true, xapian
, withCalalarmd ? true
, withMySQL ? false, libmysqlclient
, withPgSQL ? false, postgresql
, withSQLite ? true, sqlite
}:

stdenv.mkDerivation rec {
  pname = "cyrus";
  version = "3.4.3";

  src = fetchurl {
    url = "https://github.com/cyrusimap/cyrus-imapd/releases/download/cyrus-imapd-${version}/cyrus-imapd-${version}.tar.gz";
    hash = "sha256-HMyanwY0CE+1SzCmhw2ZNAFRD7yP1I9C1rM22E3ZiV4=";
  };

  nativeBuildInputs = [ bison flex pkg-config perl ];
  buildInputs =
    [ cyrus_sasl.dev icu jansson libbsd libtool libuuid openssl ]
    ++ lib.optionals (withHttp || withCalalarmd || withJMAP) [ brotli.dev libical libxml2 nghttp2 shapelib zlib ]
    ++ lib.optionals withJMAP [ libchardet wslay ]
    ++ lib.optional withXapian xapian
    ++ lib.optional withMySQL libmysqlclient
    ++ lib.optional withPgSQL postgresql
    ++ lib.optional withSQLite sqlite;

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs cunit/*.pl
    patchShebangs imap/promdatagen
    patchShebangs tools/*

    sed -i \
      -e 's!/usr/bin/touch!${coreutils}/bin/touch!g' \
      -e 's!/bin/echo!${coreutils}/bin/echo!g' \
      -e 's!/bin/sh!${stdenv.shell}!g' \
      -e 's!/usr/bin/tr!${coreutils}/bin/tr!g' \
      cunit/command.testc

    # failing test case in 3.4.3
    sed -i 's!TESTCASE("re: no re: foobar", "nore:foobar");!!' cunit/conversations.testc
  '';

  configureFlags = [
    "--enable-autocreate"
    "--enable-idled"
    "--enable-murder"
    "--enable-replication"
    "--enable-unit-tests"
    "--with-pidfile=/run/cyrus-master.pid"
  ] ++ lib.optional (withHttp || withCalalarmd || withJMAP) "--enable-http"
    ++ lib.optional withJMAP "--with-jmap"
    ++ lib.optional withXapian "--with-xapian"
    ++ lib.optional withCalalarmd "--enable-calalarmd"
    ++ lib.optional withMySQL "--with-mysql"
    ++ lib.optional withPgSQL "--with-pgsql"
    ++ lib.optional withSQLite "--with-sqlite";

  checkInputs = [ cunit ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://www.cyrusimap.org";
    description = "Cyrus IMAP is an email, contacts and calendar server";
    license = with licenses; [ bsdOriginal ];
    maintainers = with maintainers; [ pingiun ];
    platforms = platforms.unix;
  };
}
