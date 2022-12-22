{ stdenv, lib, fetchurl, makeWrapper, gnused, db, openssl, cyrus_sasl, libnsl
, coreutils, findutils, gnugrep, gawk, icu, pcre2, m4
, fetchpatch
, buildPackages, nixosTests
, withLDAP ? true, openldap
, withPgSQL ? false, postgresql
, withMySQL ? false, libmysqlclient
, withSQLite ? false, sqlite
}:

let
  ccargs = lib.concatStringsSep " " ([
    "-DUSE_TLS" "-DUSE_SASL_AUTH" "-DUSE_CYRUS_SASL" "-I${cyrus_sasl.dev}/include/sasl"
    "-DHAS_DB_BYPASS_MAKEDEFS_CHECK"
   ] ++ lib.optional withPgSQL "-DHAS_PGSQL"
     ++ lib.optionals withMySQL [ "-DHAS_MYSQL" "-I${libmysqlclient.dev}/include/mysql" "-L${libmysqlclient}/lib/mysql" ]
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
  version = "3.7.3";

  src = fetchurl {
    url = "http://cdn.postfix.johnriley.me/mirrors/postfix-release/official/${pname}-${version}.tar.gz";
    hash = "sha256-0i89N+91YT1dVztW/FHvCX8sDQsOQHkjcR9xwftykRs=";
  };

  nativeBuildInputs = [ makeWrapper m4 ];
  buildInputs = [ db openssl cyrus_sasl icu libnsl pcre2 ]
    ++ lib.optional withPgSQL postgresql
    ++ lib.optional withMySQL libmysqlclient
    ++ lib.optional withSQLite sqlite
    ++ lib.optional withLDAP openldap;

  hardeningDisable = [ "format" ];
  hardeningEnable = [ "pie" ];

  patches = [
    ./postfix-script-shell.patch
    ./postfix-3.0-no-warnings.patch
    ./post-install-script.patch
    ./relative-symlinks.patch

    # glibc 2.34 compat
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/postfix/raw/2f9d42453e67ebc43f786d98262a249037f80a77/f/postfix-3.6.2-glibc-234-build-fix.patch";
      sha256 = "sha256-xRUL5gaoIt6HagGlhsGwvwrAfYvzMgydsltYMWvl9BI=";
    })

    # linux-6 compatibility
    ./linux-6.patch
  ];

  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
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

  NIX_LDFLAGS = lib.optionalString withLDAP "-llber";

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

  passthru.tests = { inherit (nixosTests) postfix postfix-raise-smtpd-tls-security-level; };

  meta = with lib; {
    homepage = "http://www.postfix.org/";
    description = "A fast, easy to administer, and secure mail server";
    license = with licenses; [ ipl10 epl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin dotlambda lewo ];
  };
}
