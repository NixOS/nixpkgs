{ stdenv, lib, fetchurl, makeWrapper, gnused, db, openssl, cyrus_sasl, libnsl
, coreutils, findutils, gnugrep, gawk, icu, pcre, m4
, buildPackages
, withLDAP ? true, openldap
, withPgSQL ? false, postgresql
, withMySQL ? false, mysql
, withSQLite ? false, sqlite
}:

let
  ccargs = lib.concatStringsSep " " ([
    "-DUSE_TLS" "-DUSE_SASL_AUTH" "-DUSE_CYRUS_SASL" "-I${cyrus_sasl.dev}/include/sasl"
    "-DHAS_DB_BYPASS_MAKEDEFS_CHECK"
   ] ++ lib.optional withPgSQL "-DHAS_PGSQL"
     ++ lib.optionals withMySQL [ "-DHAS_MYSQL" "-I${mysql.connector-c}/include/mysql" "-L${mysql.connector-c}/lib/mysql" ]
     ++ lib.optional withSQLite "-DHAS_SQLITE"
     ++ lib.optionals withLDAP ["-DHAS_LDAP" "-DUSE_LDAP_SASL"]);
   auxlibs = lib.concatStringsSep " " ([
     "-ldb" "-lnsl" "-lresolv" "-lsasl2" "-lcrypto" "-lssl"
   ] ++ lib.optional withPgSQL "-lpq"
     ++ lib.optional withMySQL "-lmysqlclient"
     ++ lib.optional withSQLite "-lsqlite3"
     ++ lib.optional withLDAP "-lldap");

in stdenv.mkDerivation rec {

  pname = "postfix";

  version = "3.4.6";

  src = fetchurl {
    url = "ftp://ftp.cs.uu.nl/mirror/postfix/postfix-release/official/${pname}-${version}.tar.gz";
    sha256 = "09p3vg2xlh6iq45gp6zanbp1728fc31r7zz71r131vh20ssajx6n";
  };

  nativeBuildInputs = [ makeWrapper m4 ];
  buildInputs = [ db openssl cyrus_sasl icu libnsl pcre ]
                ++ lib.optional withPgSQL postgresql
                ++ lib.optional withMySQL mysql.connector-c
                ++ lib.optional withSQLite sqlite
                ++ lib.optional withLDAP openldap;

  hardeningDisable = [ "format" ];
  hardeningEnable = [ "pie" ];

  patches = [
    ./postfix-script-shell.patch
    ./postfix-3.0-no-warnings.patch
    ./post-install-script.patch
    ./relative-symlinks.patch
  ];

  postPatch = stdenv.lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -e 's!bin/postconf!${buildPackages.postfix}/bin/postconf!' -i postfix-install
  '' + ''
    sed -e '/^PATH=/d' -i postfix-install
    sed -e "s|@PACKAGE@|$out|" -i conf/post-install

    # post-install need skip permissions check/set on all symlinks following to /nix/store
    sed -e "s|@NIX_STORE@|$NIX_STORE|" -i conf/post-install
  '';

  postConfigure = ''
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

    makeFlagsArray+=(AR=$AR _AR=$AR RANLIB=$RANLIB _RANLIB=$RANLIB)

    make makefiles CCARGS='${ccargs}' AUXLIBS='${auxlibs}'
  '';

  NIX_LDFLAGS = lib.optional withLDAP "-llber";

  installTargets = [ "non-interactive-package" ];

  installFlags = [ "install_root=installdir" ];

  postInstall = ''
    mkdir -p $out
    mv -v installdir/$out/* $out/
    cp -rv installdir/etc $out
    sed -e '/^PATH=/d' -i $out/libexec/postfix/post-install
    wrapProgram $out/libexec/postfix/post-install \
      --prefix PATH ":" ${lib.makeBinPath [ coreutils findutils gnugrep ]}
    wrapProgram $out/libexec/postfix/postfix-script \
      --prefix PATH ":" ${lib.makeBinPath [ coreutils findutils gnugrep gawk gnused ]}
  '';

  meta = with lib; {
    homepage = http://www.postfix.org/;
    description = "A fast, easy to administer, and secure mail server";
    license = with licenses; [ ipl10 epl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ rickynils globin ];
  };

}
