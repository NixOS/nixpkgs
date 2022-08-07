{ stdenv
, lib
, pkgs
, fetchgit
, phpPackage
, autoconf
, pkg-config
, aspell
, bzip2
, curl
, cyrus_sasl
, enchant1
, fetchpatch
, freetds
, freetype
, gd
, gettext
, gmp
, html-tidy
, icu64
, libXpm
, libffi
, libiconv
, libjpeg
, libpng
, libsodium
, libwebp
, libxml2
, libxslt
, libzip
, net-snmp
, oniguruma
, openldap
, openssl
, pam
, pcre2
, postgresql
, re2c
, readline
, rsync
, sqlite
, unixODBC
, uwimap
, valgrind
, zlib
}:

lib.makeScope pkgs.newScope (self: with self; {
  buildPecl = import ../build-support/build-pecl.nix {
    php = php.unwrapped;
    inherit lib;
    inherit (pkgs) stdenv autoreconfHook fetchurl re2c;
  };

  # Wrap mkDerivation to prepend pname with "php-" to make names consistent
  # with how buildPecl does it and make the file easier to overview.
  mkDerivation = { pname, ... }@args: pkgs.stdenv.mkDerivation (args // {
    pname = "php-${pname}";
  });

  # Function to build an extension which is shipped as part of the php
  # source, based on the php version.
  #
  # Name passed is the name of the extension and is automatically used
  # to add the configureFlag "--enable-${name}", which can be overriden.
  #
  # Build inputs is used for extra deps that may be needed. And zendExtension
  # will mark the extension as a zend extension or not.
  mkExtension = lib.makeOverridable
    ({ name
    , configureFlags ? [ "--enable-${name}" ]
    , internalDeps ? [ ]
    , postPhpize ? ""
    , buildInputs ? [ ]
    , zendExtension ? false
    , doCheck ? true
    , ...
    }@args: stdenv.mkDerivation ((builtins.removeAttrs args [ "name" ]) // {
      pname = "php-${name}";
      extensionName = name;

      outputs = [ "out" "dev" ];

      inherit (php.unwrapped) version src;

      enableParallelBuilding = true;

      nativeBuildInputs = [
        php.unwrapped
        autoconf
        pkg-config
        re2c
      ];

      inherit configureFlags internalDeps buildInputs zendExtension doCheck;

      preConfigurePhases = [
        "cdToExtensionRootPhase"
      ];

      cdToExtensionRootPhase = ''
        # Go to extension source root.
        cd "ext/${name}"
      '';

      preConfigure = ''
        nullglobRestore=$(shopt -p nullglob)
        shopt -u nullglob   # To make ?-globbing work

        # Some extensions have a config0.m4 or config9.m4
        if [ -f config?.m4 ]; then
          mv config?.m4 config.m4
        fi

        $nullglobRestore

        phpize
        ${postPhpize}

        ${lib.concatMapStringsSep
          "\n"
          (dep: "mkdir -p ext; ln -s ${dep.dev}/include ext/${dep.extensionName}")
          internalDeps
        }
      '';

      checkPhase = ''
        runHook preCheck

        NO_INTERACTON=yes SKIP_PERF_SENSITIVE=yes make test

        runHook postCheck
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/lib/php/extensions
        cp modules/${name}.so $out/lib/php/extensions/${name}.so
        mkdir -p $dev/include
        ${rsync}/bin/rsync -r --filter="+ */" \
                              --filter="+ *.h" \
                              --filter="- *" \
                              --prune-empty-dirs \
                              . $dev/include/

        runHook postInstall
      '';

      meta = {
        description = "PHP upstream extension: ${name}";
        inherit (php.meta) maintainers homepage license;
      };
    }));

  php = phpPackage;

  # This is a set of interactive tools based on PHP.
  tools = {
    box = callPackage ../development/php-packages/box { };

    composer = callPackage ../development/php-packages/composer { };

    deployer = callPackage ../development/php-packages/deployer { };

    grumphp = callPackage ../development/php-packages/grumphp { };

    phing = callPackage ../development/php-packages/phing { };

    phive = callPackage ../development/php-packages/phive { };

    php-cs-fixer = callPackage ../development/php-packages/php-cs-fixer { };

    php-parallel-lint = callPackage ../development/php-packages/php-parallel-lint { };

    phpcbf = callPackage ../development/php-packages/phpcbf { };

    phpcs = callPackage ../development/php-packages/phpcs { };

    phpmd = callPackage ../development/php-packages/phpmd { };

    phpstan = callPackage ../development/php-packages/phpstan { };

    psalm = callPackage ../development/php-packages/psalm { };

    psysh = callPackage ../development/php-packages/psysh { };
  };



  # This is a set of PHP extensions meant to be used in php.buildEnv
  # or php.withExtensions to extend the functionality of the PHP
  # interpreter.
  extensions = {
    amqp = callPackage ../development/php-packages/amqp { };

    apcu = callPackage ../development/php-packages/apcu { };

    ast = callPackage ../development/php-packages/ast { };

    blackfire = pkgs.callPackage ../development/tools/misc/blackfire/php-probe.nix { inherit php; };

    couchbase = callPackage ../development/php-packages/couchbase { };

    datadog_trace = callPackage ../development/php-packages/datadog_trace { };

    ds = callPackage ../development/php-packages/ds { };

    event = callPackage ../development/php-packages/event { };

    gnupg = callPackage ../development/php-packages/gnupg { };

    grpc = callPackage ../development/php-packages/grpc { };

    igbinary = callPackage ../development/php-packages/igbinary { };

    imagick = callPackage ../development/php-packages/imagick { };

    mailparse = callPackage ../development/php-packages/mailparse { };

    maxminddb = callPackage ../development/php-packages/maxminddb { };

    memcached = callPackage ../development/php-packages/memcached { };

    mongodb = callPackage ../development/php-packages/mongodb { };

    oci8 = callPackage ../development/php-packages/oci8 { };

    openswoole = callPackage ../development/php-packages/openswoole { };

    pdlib = callPackage ../development/php-packages/pdlib { };

    pcov = callPackage ../development/php-packages/pcov { };

    pdo_oci = buildPecl rec {
      inherit (php.unwrapped) src version;

      pname = "pdo_oci";
      sourceRoot = "php-${version}/ext/pdo_oci";

      buildInputs = [ pkgs.oracle-instantclient ];
      configureFlags = [ "--with-pdo-oci=instantclient,${pkgs.oracle-instantclient.lib}/lib" ];

      internalDeps = [ php.extensions.pdo ];

      postPatch = ''
        sed -i -e 's|OCISDKMANINC=`.*$|OCISDKMANINC="${pkgs.oracle-instantclient.dev}/include"|' config.m4
      '';

      meta.maintainers = lib.teams.php.members;
    };

    pdo_sqlsrv = callPackage ../development/php-packages/pdo_sqlsrv { };

    pinba = callPackage ../development/php-packages/pinba { };

    protobuf = callPackage ../development/php-packages/protobuf { };

    rdkafka = callPackage ../development/php-packages/rdkafka { };

    redis = callPackage ../development/php-packages/redis { };

    smbclient = callPackage ../development/php-packages/smbclient { };

    snuffleupagus = callPackage ../development/php-packages/snuffleupagus { };

    sqlsrv = callPackage ../development/php-packages/sqlsrv { };

    swoole = callPackage ../development/php-packages/swoole { };

    xdebug = callPackage ../development/php-packages/xdebug { };

    yaml = callPackage ../development/php-packages/yaml { };
  } // (
    let
      # This list contains build instructions for different modules that one may
      # want to build.
      #
      # These will be passed as arguments to mkExtension above.
      extensionData = [
        { name = "bcmath"; }
        { name = "bz2"; buildInputs = [ bzip2 ]; configureFlags = [ "--with-bz2=${bzip2.dev}" ]; }
        { name = "calendar"; }
        { name = "ctype"; }
        {
          name = "curl";
          buildInputs = [ curl ];
          configureFlags = [ "--with-curl=${curl.dev}" ];
          doCheck = false;
        }
        { name = "dba"; }
        {
          name = "dom";
          buildInputs = [ libxml2 ];
          configureFlags = [
            "--enable-dom"
          ];
        }
        {
          name = "enchant";
          buildInputs = [ enchant1 ];
          configureFlags = [ "--with-enchant=${enchant1}" ];
          # enchant1 doesn't build on darwin.
          enable = (!stdenv.isDarwin);
          doCheck = false;
        }
        { name = "exif"; doCheck = false; }
        { name = "ffi"; buildInputs = [ libffi ]; }
        { name = "fileinfo"; buildInputs = [ pcre2 ]; }
        { name = "filter"; buildInputs = [ pcre2 ]; }
        { name = "ftp"; buildInputs = [ openssl ]; }
        {
          name = "gd";
          buildInputs = [ zlib gd ];
          configureFlags = [
            "--enable-gd"
            "--with-external-gd=${gd.dev}"
            "--enable-gd-jis-conv"
          ];
          doCheck = false;
        }
        {
          name = "gettext";
          buildInputs = [ gettext ];
          postPhpize = ''substituteInPlace configure --replace 'as_fn_error $? "Cannot locate header file libintl.h" "$LINENO" 5' ':' '';
          configureFlags = [ "--with-gettext=${gettext}" ];
        }
        {
          name = "gmp";
          buildInputs = [ gmp ];
          configureFlags = [ "--with-gmp=${gmp.dev}" ];
        }
        {
          name = "iconv";
          configureFlags = [
            "--with-iconv${lib.optionalString stdenv.isDarwin "=${libiconv}"}"
          ];
          doCheck = false;
        }
        {
          name = "imap";
          buildInputs = [ uwimap openssl pam pcre2 ];
          configureFlags = [ "--with-imap=${uwimap}" "--with-imap-ssl" ];
          # uwimap doesn't build on darwin.
          enable = (!stdenv.isDarwin);
        }
        {
          name = "intl";
          buildInputs = [ icu64 ];
        }
        {
          name = "ldap";
          buildInputs = [ openldap cyrus_sasl ];
          configureFlags = [
            "--with-ldap"
            "LDAP_DIR=${openldap.dev}"
            "LDAP_INCDIR=${openldap.dev}/include"
            "LDAP_LIBDIR=${openldap.out}/lib"
          ] ++ lib.optionals stdenv.isLinux [
            "--with-ldap-sasl=${cyrus_sasl.dev}"
          ];
          doCheck = false;
        }
        {
          name = "mbstring";
          buildInputs = [ oniguruma pcre2 ];
          doCheck = false;
        }
        {
          name = "mysqli";
          internalDeps = [ php.extensions.mysqlnd ];
          configureFlags = [ "--with-mysqli=mysqlnd" "--with-mysql-sock=/run/mysqld/mysqld.sock" ];
          doCheck = false;
        }
        {
          name = "mysqlnd";
          buildInputs = [ zlib openssl ];
          # The configure script doesn't correctly add library link
          # flags, so we add them to the variable used by the Makefile
          # when linking.
          MYSQLND_SHARED_LIBADD = "-lssl -lcrypto";
          # The configure script builds a config.h which is never
          # included. Let's include it in the main header file
          # included by all .c-files.
          patches = [
            (pkgs.writeText "mysqlnd_config.patch" ''
              --- a/ext/mysqlnd/mysqlnd.h
              +++ b/ext/mysqlnd/mysqlnd.h
              @@ -1,3 +1,6 @@
              +#ifdef HAVE_CONFIG_H
              +#include "config.h"
              +#endif
               /*
                 +----------------------------------------------------------------------+
                 | Copyright (c) The PHP Group                                          |
            '')
          ];
        }
        {
          name = "opcache";
          buildInputs = [ pcre2 ] ++ lib.optionals (!stdenv.isDarwin) [
            valgrind.dev
          ];
          zendExtension = true;
          # Tests launch the builtin webserver.
          __darwinAllowLocalNetworking = true;
        }
        {
          name = "openssl";
          buildInputs = [ openssl ];
          configureFlags = [ "--with-openssl" ];
          doCheck = false;
        }
        { name = "pcntl"; }
        { name = "pdo"; doCheck = false; }
        {
          name = "pdo_dblib";
          internalDeps = [ php.extensions.pdo ];
          configureFlags = [ "--with-pdo-dblib=${freetds}" ];
          # Doesn't seem to work on darwin.
          enable = (!stdenv.isDarwin);
          doCheck = false;
        }
        {
          name = "pdo_mysql";
          internalDeps = with php.extensions; [ pdo mysqlnd ];
          configureFlags = [ "--with-pdo-mysql=mysqlnd" "PHP_MYSQL_SOCK=/run/mysqld/mysqld.sock" ];
          doCheck = false;
        }
        {
          name = "pdo_odbc";
          internalDeps = [ php.extensions.pdo ];
          configureFlags = [ "--with-pdo-odbc=unixODBC,${unixODBC}" ];
          doCheck = false;
        }
        {
          name = "pdo_pgsql";
          internalDeps = [ php.extensions.pdo ];
          configureFlags = [ "--with-pdo-pgsql=${postgresql}" ];
          doCheck = false;
        }
        {
          name = "pdo_sqlite";
          internalDeps = [ php.extensions.pdo ];
          buildInputs = [ sqlite ];
          configureFlags = [ "--with-pdo-sqlite=${sqlite.dev}" ];
          doCheck = false;
        }
        {
          name = "pgsql";
          buildInputs = [ pcre2 ];
          configureFlags = [ "--with-pgsql=${postgresql}" ];
          doCheck = false;
        }
        { name = "posix"; doCheck = false; }
        { name = "pspell"; configureFlags = [ "--with-pspell=${aspell}" ]; }
        {
          name = "readline";
          buildInputs = [
            readline
          ];
          configureFlags = [
            "--with-readline=${readline.dev}"
          ];
          postPatch = ''
            # Fix `--with-readline` option not being available.
            # `PHP_ALWAYS_SHARED` generated by phpize enables all options
            # without the possibility to override them. But when `--with-libedit`
            # is enabled, `--with-readline` is not registered.
            echo '
            AC_DEFUN([PHP_ALWAYS_SHARED],[
              test "[$]$1" != "no" && ext_shared=yes
            ])dnl
            ' | cat - ext/readline/config.m4 > ext/readline/config.m4.tmp
            mv ext/readline/config.m4{.tmp,}
          '';
          doCheck = false;
        }
        { name = "session"; doCheck = false; }
        { name = "shmop"; }
        {
          name = "simplexml";
          buildInputs = [ libxml2 pcre2 ];
          configureFlags = [
            "--enable-simplexml"
          ];
        }
        {
          name = "snmp";
          buildInputs = [ net-snmp openssl ];
          configureFlags = [ "--with-snmp" ];
          # net-snmp doesn't build on darwin.
          enable = (!stdenv.isDarwin);
          doCheck = false;
        }
        {
          name = "soap";
          buildInputs = [ libxml2 ];
          configureFlags = [
            "--enable-soap"
          ];
          doCheck = false;
        }
        {
          name = "sockets";
          doCheck = false;
        }
        { name = "sodium"; buildInputs = [ libsodium ]; }
        { name = "sqlite3"; buildInputs = [ sqlite ]; }
        { name = "sysvmsg"; }
        { name = "sysvsem"; }
        { name = "sysvshm"; }
        { name = "tidy"; configureFlags = [ "--with-tidy=${html-tidy}" ]; doCheck = false; }
        {
          name = "tokenizer";
          patches = lib.optional (lib.versionAtLeast php.version "8.1")
            ../development/interpreters/php/fix-tokenizer-php81.patch;
        }
        {
          name = "xml";
          buildInputs = [ libxml2 ];
          configureFlags = [
            "--enable-xml"
          ];
          doCheck = false;
        }
        {
          name = "xmlreader";
          buildInputs = [ libxml2 ];
          internalDeps = [ php.extensions.dom ];
          NIX_CFLAGS_COMPILE = [ "-I../.." "-DHAVE_DOM" ];
          doCheck = false;
          configureFlags = [
            "--enable-xmlreader"
          ];
        }
        {
          name = "xmlwriter";
          buildInputs = [ libxml2 ];
          configureFlags = [
            "--enable-xmlwriter"
          ];
        }
        {
          name = "xsl";
          buildInputs = [ libxslt libxml2 ];
          doCheck = false;
          configureFlags = [ "--with-xsl=${libxslt.dev}" ];
        }
        { name = "zend_test"; }
        {
          name = "zip";
          buildInputs = [ libzip pcre2 ];
          configureFlags = [
            "--with-zip"
          ];
          doCheck = false;
        }
        {
          name = "zlib";
          buildInputs = [ zlib ];
          configureFlags = [
            "--with-zlib"
          ];
        }
      ];

      # Convert the list of attrs:
      # [ { name = <name>; ... } ... ]
      # to a list of
      # [ { name = <name>; value = <extension drv>; } ... ]
      #
      # which we later use listToAttrs to make all attrs available by name.
      #
      # Also filter out extensions based on the enable property.
      namedExtensions = builtins.map
        (drv: {
          name = drv.name;
          value = mkExtension drv;
        })
        (builtins.filter (i: i.enable or true) extensionData);

      # Produce the final attribute set of all extensions defined.
    in
    builtins.listToAttrs namedExtensions
  );
})
