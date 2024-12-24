{
  lib,
  stdenv,
  fetchurl,
  sqlite,
  postgresql,
  zlib,
  acl,
  ncurses,
  openssl,
  readline,
  gettext,
  CoreFoundation,
  IOKit,
  Kerberos,
}:

stdenv.mkDerivation rec {
  pname = "bacula";
  version = "15.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/bacula/${pname}-${version}.tar.gz";
    sha256 = "sha256-VVFcKmavmoa5VdrqQIk3i4ZNBRsubjA4O+825pOs6no=";
  };

  # libtool.m4 only matches macOS 10.*
  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    substituteInPlace configure \
      --replace "10.*)" "*)"
  '';

  buildInputs =
    [
      postgresql
      sqlite
      zlib
      ncurses
      openssl
      readline
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      gettext # bacula requires CoreFoundation, but its `configure` script will only link it when it detects libintl.
      CoreFoundation
      IOKit
      Kerberos
    ]
    # acl relies on attr, which I can't get to build on darwin
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) acl;

  configureFlags =
    [
      "--with-sqlite3=${sqlite.dev}"
      "--with-postgresql=${lib.getDev postgresql}"
      "--with-logdir=/var/log/bacula"
      "--with-working-dir=/var/lib/bacula"
      "--mandir=\${out}/share/man"
    ]
    ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "ac_cv_func_setpgrp_void=yes"
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # bacula’s `configure` script fails to detect CoreFoundation correctly,
      # but these symbols are available in the nixpkgs CoreFoundation framework.
      "gt_cv_func_CFLocaleCopyCurrent=yes"
      "gt_cv_func_CFPreferencesCopyAppValue=yes"
    ];

  installFlags = [
    "logdir=\${out}/logdir"
    "working_dir=\${out}/workdir"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/sbin/* $out/bin
  '';

  meta = with lib; {
    description = "Enterprise ready, Network Backup Tool";
    homepage = "http://bacula.org/";
    license = with licenses; [
      agpl3Only
      bsd2
    ];
    maintainers = with maintainers; [
      lovek323
      eleanor
    ];
    platforms = platforms.all;
  };
}
