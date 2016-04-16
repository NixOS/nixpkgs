{ stdenv, lib, fetchurl, makeWrapper, gnused, db, openssl, cyrus_sasl
, coreutils, findutils, gnugrep, gawk, icu, pcre
, withPgSQL ? false, postgresql
, withMySQL ? false, libmysql
, withSQLite ? false, sqlite
}:

let
  ccargs = lib.concatStringsSep " " ([
    "-DUSE_TLS" "-DUSE_SASL_AUTH" "-DUSE_CYRUS_SASL" "-I${cyrus_sasl.dev}/include/sasl"
    "-DHAS_DB_BYPASS_MAKEDEFS_CHECK"
    "-fPIE" "-fstack-protector-all" "--param" "ssp-buffer-size=4" "-O2" "-D_FORTIFY_SOURCE=2"
   ] ++ lib.optional withPgSQL "-DHAS_PGSQL"
     ++ lib.optionals withMySQL [ "-DHAS_MYSQL" "-I${libmysql}/include/mysql" ]
     ++ lib.optional withSQLite "-DHAS_SQLITE");
   auxlibs = lib.concatStringsSep " " ([
     "-ldb" "-lnsl" "-lresolv" "-lsasl2" "-lcrypto" "-lssl" "-pie" "-Wl,-z,relro,-z,now"
   ] ++ lib.optional withPgSQL "-lpq"
     ++ lib.optional withMySQL "-lmysqlclient"
     ++ lib.optional withSQLite "-lsqlite3");

in stdenv.mkDerivation rec {

  name = "postfix-${version}";

  version = "3.0.4";

  src = fetchurl {
    url = "ftp://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/${name}.tar.gz";
    sha256 = "03msimdzxndm1nskljarws45wpqk020ckfcrmn1p3pxrfq8yh75q";
  };

  buildInputs = [ makeWrapper gnused db openssl cyrus_sasl icu pcre ]
                ++ lib.optional withPgSQL postgresql
                ++ lib.optional withMySQL libmysql
                ++ lib.optional withSQLite sqlite;

  patches = [
    ./postfix-script-shell.patch
    ./postfix-3.0-no-warnings.patch
    ./post-install-script.patch
    ./relative-symlinks.patch
  ];

  preBuild = ''
    sed -e '/^PATH=/d' -i postfix-install
    sed -e "s|@PACKAGE@|$out|" -i conf/post-install

    # post-install need skip permissions check/set on all symlinks following to /nix/store
    sed -e "s|@NIX_STORE@|$NIX_STORE|" -i conf/post-install

    export command_directory=$out/sbin
    export config_directory=/etc/postfix
    export meta_directory=$out/etc/postfix
    export daemon_directory=$out/libexec/postfix
    export data_directory=/var/lib/postfix/data
    export html_directory=$out/share/postfix/doc/html
    export mailq_path=$out/bin/mailq
    export manpage_directory=$out/share/man
    export newaliases_path=$out/bin/newaliases
    export queue_directory=/var/lib/postfix/queue
    export readme_directory=$out/share/postfix/doc
    export sendmail_path=$out/bin/sendmail

    make makefiles CCARGS='${ccargs}' AUXLIBS='${auxlibs}'
  '';

  installTargets = [ "non-interactive-package" ];

  installFlags = [ "install_root=installdir" ];

  postInstall = ''
    mkdir -p $out
    mv -v installdir/$out/* $out/
    cp -rv installdir/etc $out
    sed -e '/^PATH=/d' -i $out/libexec/postfix/post-install
    wrapProgram $out/libexec/postfix/post-install \
      --prefix PATH ":" ${coreutils}/bin:${findutils}/bin:${gnugrep}/bin
    wrapProgram $out/libexec/postfix/postfix-script \
      --prefix PATH ":" ${coreutils}/bin:${findutils}/bin:${gnugrep}/bin:${gawk}/bin:${gnused}/bin
  '';

  meta = {
    homepage = "http://www.postfix.org/";
    description = "A fast, easy to administer, and secure mail server";
    license = lib.licenses.bsdOriginal;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.rickynils ];
  };

}
