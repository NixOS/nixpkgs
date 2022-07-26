{ lib, stdenv, fetchurl, sqlite, postgresql, zlib, acl, ncurses, openssl, readline
, CoreFoundation, IOKit
}:

stdenv.mkDerivation rec {
  pname = "bacula";
  version = "11.0.6";

  src = fetchurl {
    url    = "mirror://sourceforge/bacula/${pname}-${version}.tar.gz";
    sha256 = "sha256-AZWgi81PV4rkqc4Nkff4ZzHGNNVrgQU0ci1yGyqe7Lc=";
  };

  buildInputs = [ postgresql sqlite zlib ncurses openssl readline ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreFoundation
      IOKit
    ]
    # acl relies on attr, which I can't get to build on darwin
    ++ lib.optional (!stdenv.isDarwin) acl;

  configureFlags = [
    "--with-sqlite3=${sqlite.dev}"
    "--with-postgresql=${postgresql}"
    "--with-logdir=/var/log/bacula"
    "--with-working-dir=/var/lib/bacula"
    "--mandir=\${out}/share/man"
  ] ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "ac_cv_func_setpgrp_void=yes";

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
    homepage    = "http://bacula.org/";
    license     = with licenses; [ agpl3Only bsd2 ];
    maintainers = with maintainers; [ lovek323 eleanor ];
    platforms   = platforms.all;
  };
}
