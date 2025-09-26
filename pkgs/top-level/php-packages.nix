{
  stdenv,
  config,
  callPackages,
  lib,
  pkgs,
  phpPackage,
  autoconf,
  pkg-config,
  bzip2,
  curl,
  cyrus_sasl,
  enchant2,
  freetds,
  gd,
  gettext,
  gmp,
  html-tidy,
  icu73,
  libffi,
  libiconv,
  libkrb5,
  libpq,
  libsodium,
  libxml2,
  libxslt,
  libzip,
  net-snmp,
  nix-update-script,
  oniguruma,
  openldap,
  openssl_1_1,
  openssl,
  pam,
  pcre2,
  bison,
  re2c,
  readline,
  rsync,
  sqlite,
  unixODBC,
  uwimap,
  valgrind,
  zlib,
}:

lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self)
      buildPecl
      callPackage
      mkExtension
      php
      ;

    builders = import ../build-support/php/builders {
      inherit callPackages callPackage buildPecl;
    };
  in
  {
    buildPecl = callPackage ../build-support/php/build-pecl.nix {
      php = php.unwrapped;
    };

    inherit (builders.v1)
      buildComposerProject
      buildComposerWithPlugin
      composerHooks
      mkComposerRepository
      ;

    # Next version of the builder
    buildComposerProject2 = builders.v2.buildComposerProject;
    composerHooks2 = builders.v2.composerHooks;
    mkComposerVendor = builders.v2.mkComposerVendor;

    # Wrap mkDerivation to prepend pname with "php-" to make names consistent
    # with how buildPecl does it and make the file easier to overview.
    mkDerivation =
      origArgs:
      let
        args = lib.fix (
          lib.extends (_: previousAttrs: {
            pname = "php-${previousAttrs.pname}";
            passthru = (previousAttrs.passthru or { }) // {
              updateScript = nix-update-script { };
            };
            meta = (previousAttrs.meta or { }) // {
              mainProgram = previousAttrs.meta.mainProgram or previousAttrs.pname;
            };
          }) (if lib.isFunction origArgs then origArgs else (_: origArgs))
        );
      in
      pkgs.stdenv.mkDerivation args;

    # Function to build an extension which is shipped as part of the php
    # source, based on the php version.
    #
    # Name passed is the name of the extension and is automatically used
    # to add the configureFlag "--enable-${name}", which can be overridden.
    #
    # Build inputs is used for extra deps that may be needed. And zendExtension
    # will mark the extension as a zend extension or not.
    mkExtension = lib.makeOverridable (
      {
        name,
        configureFlags ? [ "--enable-${extName}" ],
        internalDeps ? [ ],
        postPhpize ? "",
        buildInputs ? [ ],
        zendExtension ? false,
        doCheck ? true,
        extName ? name,
        ...
      }@args:
      stdenv.mkDerivation (
        (builtins.removeAttrs args [ "name" ])
        // {
          pname = "php-${name}";
          extensionName = extName;

          outputs = [
            "out"
            "dev"
          ];

          inherit (php.unwrapped) version src;

          enableParallelBuilding = true;

          nativeBuildInputs = [
            php.unwrapped
            autoconf
            pkg-config
            re2c
            bison
          ];

          inherit
            configureFlags
            internalDeps
            buildInputs
            zendExtension
            doCheck
            ;

          preConfigurePhases = [
            "genfiles"
            "cdToExtensionRootPhase"
          ];

          genfiles = ''
            if [ -f "scripts/dev/genfiles" ]; then
              ./scripts/dev/genfiles
            fi
          '';

          cdToExtensionRootPhase = ''
            # Go to extension source root.
            cd "ext/${extName}"
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

            ${lib.concatMapStringsSep "\n" (
              dep: "mkdir -p ext; ln -s ${dep.dev}/include ext/${dep.extensionName}"
            ) internalDeps}
          '';

          checkPhase = ''
            runHook preCheck

            NO_INTERACTION=yes SKIP_PERF_SENSITIVE=yes SKIP_ONLINE_TESTS=yes make test
            runHook postCheck
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/lib/php/extensions
            cp modules/${extName}.so $out/lib/php/extensions/${extName}.so
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
            inherit (php.meta)
              teams
              homepage
              license
              platforms
              ;
          }
          // args.meta or { };
        }
      )
    );

    php = phpPackage;

    # This is a set of interactive tools based on PHP.
    tools = {
      box = callPackage ../development/php-packages/box { };

      castor = callPackage ../development/php-packages/castor { };

      composer = callPackage ../development/php-packages/composer { };

      composer-local-repo-plugin = callPackage ../development/php-packages/composer-local-repo-plugin { };

      cyclonedx-php-composer = callPackage ../development/php-packages/cyclonedx-php-composer { };

      grumphp = callPackage ../development/php-packages/grumphp { };

      phan = callPackage ../development/php-packages/phan { };

      phing = callPackage ../development/php-packages/phing { };

      phive = callPackage ../development/php-packages/phive { };

      php-codesniffer = callPackage ../development/php-packages/php-codesniffer { };

      php-cs-fixer = callPackage ../development/php-packages/php-cs-fixer { };

      php-parallel-lint = callPackage ../development/php-packages/php-parallel-lint { };

      phpinsights = callPackage ../development/php-packages/phpinsights { };

      phpmd = callPackage ../development/php-packages/phpmd { };

      phpspy = callPackage ../development/php-packages/phpspy { };

      phpstan = callPackage ../development/php-packages/phpstan { };

      psalm = callPackage ../development/php-packages/psalm { };
    }
    // lib.optionalAttrs config.allowAliases {
      deployer = throw "`php8${lib.versions.minor php.version}Packages.deployer` has been removed, use `deployer`";
      phpcbf = throw "`php8${lib.versions.minor php.version}Packages.phpcbf` has been removed, use `php-codesniffer` instead which contains both `phpcs` and `phpcbf`.";
      phpcs = throw "`php8${lib.versions.minor php.version}Packages.phpcs` has been removed, use `php-codesniffer` instead which contains both `phpcs` and `phpcbf`.";
      psysh = throw "`php8${lib.versions.minor php.version}Packages.psysh` has been removed, use `psysh`";
    };

    # This is a set of PHP extensions meant to be used in php.buildEnv
    # or php.withExtensions to extend the functionality of the PHP
    # interpreter.
    # The extensions attributes is composed of three sections:
    # 1. The contrib conditional extensions, which are only available on specific PHP versions
    # 2. The contrib extensions available
    # 3. The core extensions
    extensions =
      # Contrib extensions
      {
        amqp = callPackage ../development/php-packages/amqp { };

        apcu = callPackage ../development/php-packages/apcu { };

        ast = callPackage ../development/php-packages/ast { };

        blackfire = callPackage ../by-name/bl/blackfire/php-probe.nix { };

        couchbase = callPackage ../development/php-packages/couchbase { };

        datadog_trace = callPackage ../development/php-packages/datadog_trace { };

        decimal = callPackage ../development/php-packages/decimal { };

        ds = callPackage ../development/php-packages/ds { };

        event = callPackage ../development/php-packages/event { };

        excimer = callPackage ../development/php-packages/excimer { };

        gnupg = callPackage ../development/php-packages/gnupg { };

        grpc = callPackage ../development/php-packages/grpc { };

        igbinary = callPackage ../development/php-packages/igbinary { };

        imagick = callPackage ../development/php-packages/imagick { };

        # Shadowed by built-in version on PHP < 8.3.
        imap = callPackage ../development/php-packages/imap { };

        inotify = callPackage ../development/php-packages/inotify { };

        ioncube-loader = callPackage ../development/php-packages/ioncube-loader { };

        luasandbox = callPackage ../development/php-packages/luasandbox { };

        mailparse = callPackage ../development/php-packages/mailparse { };

        maxminddb = callPackage ../development/php-packages/maxminddb { };

        memcache = callPackage ../development/php-packages/memcache { };

        memcached = callPackage ../development/php-packages/memcached { };

        meminfo = callPackage ../development/php-packages/meminfo { };

        memprof = callPackage ../development/php-packages/memprof { };

        mongodb = callPackage ../development/php-packages/mongodb { };

        msgpack = callPackage ../development/php-packages/msgpack { };

        oci8 = callPackage ../development/php-packages/oci8 { };

        opentelemetry = callPackage ../development/php-packages/opentelemetry { };

        openswoole = callPackage ../development/php-packages/openswoole { };

        parallel = callPackage ../development/php-packages/parallel { };

        pdlib = callPackage ../development/php-packages/pdlib { };

        pcov = callPackage ../development/php-packages/pcov { };

        pdo_oci =
          if (lib.versionAtLeast php.version "8.4") then
            callPackage ../development/php-packages/pdo_oci { }
          else
            buildPecl rec {
              inherit (php.unwrapped) src version;

              pname = "pdo_oci";
              sourceRoot = "php-${version}/ext/pdo_oci";

              buildInputs = [ pkgs.oracle-instantclient ];
              configureFlags = [ "--with-pdo-oci=instantclient,${pkgs.oracle-instantclient.lib}/lib" ];

              internalDeps = [ php.extensions.pdo ];
              postPatch = ''
                sed -i -e 's|OCISDKMANINC=`.*$|OCISDKMANINC="${pkgs.oracle-instantclient.dev}/include"|' config.m4
              '';

              meta.teams = [ lib.teams.php ];
            };

        pdo_sqlsrv = callPackage ../development/php-packages/pdo_sqlsrv { };

        phalcon = callPackage ../development/php-packages/phalcon { };

        pinba = callPackage ../development/php-packages/pinba { };

        protobuf = callPackage ../development/php-packages/protobuf { };

        pspell = callPackage ../development/php-packages/pspell { };

        rdkafka = callPackage ../development/php-packages/rdkafka { };

        redis = callPackage ../development/php-packages/redis { };

        relay = callPackage ../development/php-packages/relay { };

        rrd = callPackage ../development/php-packages/rrd { };

        smbclient = callPackage ../development/php-packages/smbclient { };

        snuffleupagus = callPackage ../development/php-packages/snuffleupagus { };

        spx = callPackage ../development/php-packages/spx { };

        sqlsrv = callPackage ../development/php-packages/sqlsrv { };

        ssh2 = callPackage ../development/php-packages/ssh2 { };

        swoole = callPackage ../development/php-packages/swoole { };

        systemd = callPackage ../development/php-packages/systemd { };

        tideways = callPackage ../development/php-packages/tideways { };

        uuid = callPackage ../development/php-packages/uuid { };

        uv = callPackage ../development/php-packages/uv { };

        vld = callPackage ../development/php-packages/vld { };

        wikidiff2 = callPackage ../development/php-packages/wikidiff2 { };

        xdebug = callPackage ../development/php-packages/xdebug { };

        yaml = callPackage ../development/php-packages/yaml { };

        zstd = callPackage ../development/php-packages/zstd { };
      }
      // lib.optionalAttrs config.allowAliases {
        php-spx = throw "php-spx is deprecated, use spx instead";
      }
      // (
        # Core extensions
        let
          # This list contains build instructions for different modules that one may
          # want to build.
          #
          # These will be passed as arguments to mkExtension above.
          extensionData = [
            { name = "bcmath"; }
            {
              name = "bz2";
              buildInputs = [ bzip2 ];
              configureFlags = [ "--with-bz2=${bzip2.dev}" ];
            }
            { name = "calendar"; }
            {
              name = "ctype";
              postPatch =
                lib.optionalString (stdenv.hostPlatform.isDarwin && lib.versionAtLeast php.version "8.2")
                  # Broken test on aarch64-darwin
                  ''
                    rm ext/ctype/tests/lc_ctype_inheritance.phpt
                  '';
            }
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
              buildInputs = [ enchant2 ];
              configureFlags = [ "--with-enchant" ];
              doCheck = false;
            }
            {
              name = "exif";
              doCheck = false;
            }
            {
              name = "ffi";
              buildInputs = [ libffi ];
            }
            {
              name = "fileinfo";
              buildInputs = [ pcre2 ];
            }
            {
              name = "filter";
              buildInputs = [ pcre2 ];
            }
            {
              name = "ftp";
              buildInputs = [ openssl ];
            }
            {
              name = "gd";
              buildInputs = [
                zlib
                gd
              ];
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
              postPhpize = ''substituteInPlace configure --replace-fail 'as_fn_error $? "Cannot locate header file libintl.h" "$LINENO" 5' ':' '';
              configureFlags = [ "--with-gettext=${gettext}" ];
            }
            {
              name = "gmp";
              buildInputs = [ gmp ];
              configureFlags = [ "--with-gmp=${gmp.dev}" ];
            }
            {
              name = "iconv";
              buildInputs = [ libiconv ];
              configureFlags = [ "--with-iconv" ];
              # Some other extensions support separate libdirs, but iconv does not. This causes problems with detecting
              # Darwin’s libiconv because it has separate outputs. Adding `-liconv` works around the issue.
              env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { NIX_LDFLAGS = "-liconv"; };
              doCheck = stdenv.hostPlatform.isLinux;
            }
            {
              name = "intl";
              buildInputs = [ icu73 ];
            }
            {
              name = "ldap";
              buildInputs = [
                openldap
                cyrus_sasl
              ];
              configureFlags = [
                "--with-ldap"
                "LDAP_DIR=${openldap.dev}"
                "LDAP_INCDIR=${openldap.dev}/include"
                "LDAP_LIBDIR=${openldap.out}/lib"
              ]
              ++ lib.optionals stdenv.hostPlatform.isLinux [
                "--with-ldap-sasl=${cyrus_sasl.dev}"
              ];
              doCheck = false;
            }
            {
              name = "mbstring";
              buildInputs = [
                oniguruma
                pcre2
              ];
              doCheck = false;
            }
            {
              name = "mysqli";
              internalDeps = [ php.extensions.mysqlnd ];
              configureFlags = [
                "--with-mysqli=mysqlnd"
                "--with-mysql-sock=/run/mysqld/mysqld.sock"
              ];
              doCheck = false;
            }
            {
              name = "mysqlnd";
              buildInputs = [
                zlib
                openssl
              ];
              configureFlags = [ "--with-mysqlnd-ssl" ];
              # The configure script doesn't correctly add library link
              # flags, so we add them to the variable used by the Makefile
              # when linking.
              MYSQLND_SHARED_LIBADD = "-lz -lssl -lcrypto";
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
              buildInputs = [
                pcre2
              ]
              ++ lib.optional (
                !stdenv.hostPlatform.isDarwin && lib.meta.availableOn stdenv.hostPlatform valgrind
              ) valgrind.dev;
              configureFlags = lib.optional php.ztsSupport "--disable-opcache-jit";
              zendExtension = true;
              postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
                # Tests are flaky on darwin
                rm ext/opcache/tests/blacklist.phpt
                rm ext/opcache/tests/bug66338.phpt
                rm ext/opcache/tests/bug78106.phpt
                rm ext/opcache/tests/issue0115.phpt
                rm ext/opcache/tests/issue0149.phpt
                rm ext/opcache/tests/revalidate_path_01.phpt
              '';
              # Tests launch the builtin webserver.
              __darwinAllowLocalNetworking = true;
            }
            {
              name = "openssl";
              buildInputs = [ openssl ];
              configureFlags = [ "--with-openssl" ];
              doCheck = false;
            }
            # This provides a legacy OpenSSL PHP extension
            # For situations where OpenSSL 3 do not support a set of features
            # without a specific openssl.cnf file
            {
              name = "openssl-legacy";
              extName = "openssl";
              buildInputs = [ openssl_1_1 ];
              configureFlags = [ "--with-openssl" ];
              doCheck = false;
            }
            { name = "pcntl"; }
            {
              name = "pdo";
              doCheck = false;
            }
            {
              name = "pdo_dblib";
              internalDeps = [ php.extensions.pdo ];
              configureFlags = [ "--with-pdo-dblib=${freetds}" ];
              meta.broken = stdenv.hostPlatform.isDarwin;
              doCheck = false;
            }
            {
              name = "pdo_mysql";
              internalDeps = with php.extensions; [
                pdo
                mysqlnd
              ];
              configureFlags = [
                "--with-pdo-mysql=mysqlnd"
                "PHP_MYSQL_SOCK=/run/mysqld/mysqld.sock"
              ];
              doCheck = false;
            }
            {
              name = "pdo_odbc";
              internalDeps = [ php.extensions.pdo ];
              buildInputs = [ unixODBC ];
              configureFlags = [ "--with-pdo-odbc=unixODBC,${unixODBC}" ];
              doCheck = false;
            }
            {
              name = "pdo_pgsql";
              internalDeps = [ php.extensions.pdo ];
              configureFlags = [ "--with-pdo-pgsql=${libpq.pg_config}" ];
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
              buildInputs = [
                pcre2
              ];
              configureFlags = [ "--with-pgsql=${libpq.pg_config}" ];
              doCheck = false;
            }
            {
              name = "posix";
              doCheck = false;
            }
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
            {
              name = "session";
              doCheck = false;
            }
            { name = "shmop"; }
            {
              name = "simplexml";
              buildInputs = [
                libxml2
                pcre2
              ];
              configureFlags = [
                "--enable-simplexml"
              ];
            }
            {
              name = "snmp";
              buildInputs = [
                net-snmp
                openssl
              ];
              configureFlags = [ "--with-snmp" ];
              doCheck = false;
            }
            {
              name = "soap";
              buildInputs = [ libxml2 ];
              configureFlags = [
                "--enable-soap"
              ];
              # Some tests are causing issues in the Darwin sandbox with issues
              # such as
              #   Unknown: php_network_getaddresses: getaddrinfo for localhost failed: nodename nor servname provided
              doCheck = !stdenv.hostPlatform.isDarwin && lib.versionOlder php.version "8.4";
              internalDeps = [ php.extensions.session ];
            }
            {
              name = "sockets";
              doCheck = false;
            }
            {
              name = "sodium";
              buildInputs = [ libsodium ];
            }
            {
              name = "sqlite3";
              buildInputs = [ sqlite ];

              # The `sqlite3_bind_bug68849.phpt` test is currently broken for i686 Linux systems since sqlite 3.43, cf.:
              # - https://github.com/php/php-src/issues/12076
              # - https://www.sqlite.org/forum/forumpost/abbb95376ec6cd5f
              patches = lib.optionals (stdenv.hostPlatform.isi686 && stdenv.hostPlatform.isLinux) [
                ../development/interpreters/php/skip-sqlite3_bind_bug68849.phpt.patch
              ];
            }
            { name = "sysvmsg"; }
            { name = "sysvsem"; }
            { name = "sysvshm"; }
            {
              name = "tidy";
              configureFlags = [ "--with-tidy=${html-tidy}" ];
              doCheck = false;
            }
            {
              name = "tokenizer";
              patches = [ ../development/interpreters/php/fix-tokenizer-php81.patch ];
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
              env.NIX_CFLAGS_COMPILE = toString [
                "-I../.."
                "-DHAVE_DOM"
              ];
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
              buildInputs = [
                libxslt
                libxml2
              ];
              internalDeps = [ php.extensions.dom ];
              doCheck = false;
              env.NIX_CFLAGS_COMPILE = toString [
                "-I../.."
                "-DHAVE_DOM"
              ];
              configureFlags = [ "--with-xsl=${libxslt.dev}" ];
            }
            {
              name = "zend_test";
              internalDeps = [ php.extensions.dom ];
              env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";
            }
            {
              name = "zip";
              buildInputs = [
                libzip
                pcre2
              ];
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
          ]
          ++ lib.optionals (lib.versionOlder php.version "8.3") [
            # Using version from PECL on new PHP versions.
            {
              name = "imap";
              buildInputs = [
                uwimap
                openssl
                pam
                pcre2
                libkrb5
              ];
              configureFlags = [
                "--with-imap=${uwimap}"
                "--with-imap-ssl"
                "--with-kerberos"
              ];
            }
          ];

          # Convert the list of attrs:
          # [ { name = <name>; ... } ... ]
          # to a list of
          # [ { name = <name>; value = <extension drv>; } ... ]
          #
          # which we later use listToAttrs to make all attrs available by name.
          namedExtensions = builtins.map (drv: {
            name = drv.name;
            value = mkExtension drv;
          }) extensionData;

        in
        # Produce the final attribute set of all extensions defined.
        builtins.listToAttrs namedExtensions
      );
  }
)
