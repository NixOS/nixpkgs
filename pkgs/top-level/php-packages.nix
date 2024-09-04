{ stdenv
, config
, callPackages
, lib
, pkgs
, phpPackage
, autoconf
, pkg-config
, bzip2
, curl
, cyrus_sasl
, enchant2
, freetds
, gd
, gettext
, gmp
, html-tidy
, icu73
, libffi
, libiconv
, libkrb5
, libsodium
, libxml2
, libxslt
, libzip
, net-snmp
, nix-update-script
, oniguruma
, openldap
, openssl_1_1
, openssl
, overrideSDK
, pam
, pcre2
, postgresql
, bison
, re2c
, readline
, rsync
, sqlite
, unixODBC
, uwimap
, valgrind
, zlib
, fetchpatch
}:

lib.makeScope pkgs.newScope (self: let
  inherit (self) buildPecl callPackage mkExtension php;

  builders = import ../build-support/php/builders {
    inherit callPackages callPackage buildPecl;
  };
in {
  buildPecl = callPackage ../build-support/php/build-pecl.nix {
    php = php.unwrapped;
  };

  inherit (builders.v1) buildComposerProject buildComposerWithPlugin composerHooks mkComposerRepository;

  # Next version of the builder
  buildComposerProject2 = builders.v2.buildComposerProject;
  composerHooks2 = builders.v2.composerHooks;
  mkComposerVendor = builders.v2.mkComposerVendor;

  # Wrap mkDerivation to prepend pname with "php-" to make names consistent
  # with how buildPecl does it and make the file easier to overview.
  mkDerivation = origArgs:
    let
      args = lib.fix (lib.extends
        (_: previousAttrs: {
          pname = "php-${previousAttrs.pname}";
          passthru = (previousAttrs.passthru or { }) // {
            updateScript = nix-update-script { };
          };
          meta = (previousAttrs.meta or { }) // {
            mainProgram = previousAttrs.meta.mainProgram or previousAttrs.pname;
          };
        })
        (if lib.isFunction origArgs then origArgs else (_: origArgs))
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
  mkExtension = lib.makeOverridable
    ({ name
     , configureFlags ? [ "--enable-${extName}" ]
     , internalDeps ? [ ]
     , postPhpize ? ""
     , buildInputs ? [ ]
     , zendExtension ? false
     , doCheck ? true
     , extName ? name
     , ...
     }@args: stdenv.mkDerivation ((builtins.removeAttrs args [ "name" ]) // {
      pname = "php-${name}";
      extensionName = extName;

      outputs = [ "out" "dev" ];

      inherit (php.unwrapped) version src;

      enableParallelBuilding = true;

      nativeBuildInputs = [
        php.unwrapped
        autoconf
        pkg-config
        re2c
        bison
      ];

      inherit configureFlags internalDeps buildInputs zendExtension doCheck;

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

        ${lib.concatMapStringsSep
          "\n"
          (dep: "mkdir -p ext; ln -s ${dep.dev}/include ext/${dep.extensionName}")
          internalDeps
        }
      '';

      checkPhase = ''
        runHook preCheck

        NO_INTERACTION=yes SKIP_PERF_SENSITIVE=yes make test
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
        inherit (php.meta) maintainers homepage license;
      };
    }));

  php = phpPackage;

  # This is a set of interactive tools based on PHP.
  tools = {
    box = callPackage ../development/php-packages/box { };

    castor = callPackage ../development/php-packages/castor { };

    composer = callPackage ../development/php-packages/composer { };

    composer-local-repo-plugin = callPackage ../development/php-packages/composer-local-repo-plugin { };

    cyclonedx-php-composer = callPackage ../development/php-packages/cyclonedx-php-composer { };

    deployer = callPackage ../development/php-packages/deployer { };

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

    psysh = callPackage ../development/php-packages/psysh { };
  } // lib.optionalAttrs config.allowAliases {
    phpcbf = throw "`phpcbf` is now deprecated, use `php-codesniffer` instead which contains both `phpcs` and `phpcbf`.";
    phpcs = throw "`phpcs` is now deprecated, use `php-codesniffer` instead which contains both `phpcs` and `phpcbf`.";
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

    blackfire = callPackage ../development/tools/misc/blackfire/php-probe.nix { };

    couchbase = callPackage ../development/php-packages/couchbase { };

    datadog_trace = callPackage ../development/php-packages/datadog_trace {
      buildPecl = buildPecl.override {
        stdenv = if stdenv.isDarwin then overrideSDK stdenv "11.0" else stdenv;
      };
      inherit (pkgs) darwin;
    };

    ds = callPackage ../development/php-packages/ds { };

    event = callPackage ../development/php-packages/event { };

    gnupg = callPackage ../development/php-packages/gnupg { };

    grpc = callPackage ../development/php-packages/grpc { };

    igbinary = callPackage ../development/php-packages/igbinary { };

    imagick = callPackage ../development/php-packages/imagick { };

    # Shadowed by built-in version on PHP < 8.3.
    imap = callPackage ../development/php-packages/imap { };

    inotify = callPackage ../development/php-packages/inotify { };

    ioncube-loader = callPackage ../development/php-packages/ioncube-loader { };

    mailparse = callPackage ../development/php-packages/mailparse { };

    maxminddb = callPackage ../development/php-packages/maxminddb { };

    memcache = callPackage ../development/php-packages/memcache { };

    memcached = callPackage ../development/php-packages/memcached { };

    meminfo = callPackage ../development/php-packages/meminfo { };

    memprof = callPackage ../development/php-packages/memprof { };

    mongodb = callPackage ../development/php-packages/mongodb {
      inherit (pkgs) darwin;
    };

    msgpack = callPackage ../development/php-packages/msgpack { };

    oci8 = callPackage ../development/php-packages/oci8 { };

    opentelemetry = callPackage ../development/php-packages/opentelemetry { };

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

    phalcon = callPackage ../development/php-packages/phalcon { };

    pinba = callPackage ../development/php-packages/pinba { };

    protobuf = callPackage ../development/php-packages/protobuf { };

    pspell = callPackage ../development/php-packages/pspell { };

    rdkafka = callPackage ../development/php-packages/rdkafka { };

    redis = callPackage ../development/php-packages/redis { };

    relay = callPackage ../development/php-packages/relay { };

    rrd = callPackage ../development/php-packages/rrd { };

    smbclient = callPackage ../development/php-packages/smbclient { };

    snuffleupagus = callPackage ../development/php-packages/snuffleupagus {
      inherit (pkgs) darwin;
    };

    spx = callPackage ../development/php-packages/spx { };

    sqlsrv = callPackage ../development/php-packages/sqlsrv { };

    ssh2 = callPackage ../development/php-packages/ssh2 { };

    swoole = callPackage ../development/php-packages/swoole { };

    uv = callPackage ../development/php-packages/uv { };

    vld = callPackage ../development/php-packages/vld { };

    xdebug = callPackage ../development/php-packages/xdebug { };

    yaml = callPackage ../development/php-packages/yaml { };

    zstd = callPackage ../development/php-packages/zstd { };
  } // lib.optionalAttrs config.allowAliases {
    php-spx = throw "php-spx is deprecated, use spx instead";
  } // (
    # Core extensions
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
          # Add a PHP lower version bound constraint to avoid applying the patch on older PHP versions.
          patches = lib.optionals ((lib.versions.majorMinor php.version == "8.2" && lib.versionOlder php.version "8.2.14" && lib.versionAtLeast php.version "8.2.7") || (lib.versions.majorMinor php.version == "8.1")) [
            # Fix tests with libxml 2.12
            # Part of 8.3.1RC1+, 8.2.14RC1+
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/061058a9b1bbd90d27d97d79aebcf2b5029767b0.patch";
              hash = "sha256-0hOlAG+pOYp/gUU0MUMZvzWpgr0ncJi5GB8IeNxxyEU=";
              excludes = [
                "NEWS"
              ];
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.1") [
            # Backport of PHP_LIBXML_IGNORE_DEPRECATIONS_START and PHP_LIBXML_IGNORE_DEPRECATIONS_END
            ../development/interpreters/php/php81-fix-libxml2-2.13-compatibility.patch
            # Fix build with libxml2 2.13+. Has to be applied after libxml2 2.12 patch.
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/9b4f6b09d58a4e54ee60443bf9a8b166852c03e0.patch";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.2" && lib.versionOlder php.version "8.2.22") [
            # Fixes compatibility with libxml2 2.13. Part of 8.3.10RC1+, 8.2.22RC1+
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/4fe821311cafb18ca8bdf20b9d796c48a13ba552.diff?full_index=1";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.3" && lib.versionOlder php.version "8.3.10") [
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/ecf0bb0fd12132d853969c5e9a212e5f627f2da2.diff?full_index=1";
              hash = "sha256-sodGODHb4l04P0srn3L8l3K+DjZzCsCNbamfkmIyF+k=";
              excludes = [ "NEWS" ];
            })
          ];
        }
        {
          name = "enchant";
          buildInputs = [ enchant2 ];
          configureFlags = [ "--with-enchant" ];
          doCheck = false;
        }
        { name = "exif"; doCheck = false; }
        { name = "ffi"; buildInputs = [ libffi ]; }
        {
          name = "fileinfo";
          buildInputs = [ pcre2 ];
        }
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
          doCheck = stdenv.isLinux;
        }
        {
          name = "imap";
          buildInputs = [ uwimap openssl pam pcre2 libkrb5 ];
          configureFlags = [ "--with-imap=${uwimap}" "--with-imap-ssl" "--with-kerberos" ];
          # Using version from PECL on new PHP versions.
          enable = lib.versionOlder php.version "8.3";
        }
        {
          name = "intl";
          buildInputs = [ icu73 ];
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
          buildInputs = [ pcre2 ] ++
            lib.optional
              (!stdenv.isDarwin && lib.meta.availableOn stdenv.hostPlatform valgrind)
              valgrind.dev;
          configureFlags = lib.optional php.ztsSupport "--disable-opcache-jit";
          zendExtension = true;
          postPatch = lib.optionalString stdenv.isDarwin ''
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
          buildInputs = [ unixODBC ];
          configureFlags = [ "--with-pdo-odbc=unixODBC,${unixODBC}" ];
          doCheck = false;
        }
        {
          name = "pdo_pgsql";
          internalDeps = [ php.extensions.pdo ];
          configureFlags = [ "--with-pdo-pgsql=${lib.getDev postgresql}" ];
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
          configureFlags = [ "--with-pgsql=${lib.getDev postgresql}" ];
          doCheck = false;
        }
        { name = "posix"; doCheck = false; }
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
        { name = "session";
          doCheck = false;
        }
        { name = "shmop"; }
        {
          name = "simplexml";
          buildInputs = [ libxml2 pcre2 ];
          configureFlags = [
            "--enable-simplexml"
          ];
          patches = lib.optionals (lib.versions.majorMinor php.version == "8.1") [
            # Fix tests with libxml2 2.12
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/061058a9b1bbd90d27d97d79aebcf2b5029767b0.patch";
              hash = "sha256-0hOlAG+pOYp/gUU0MUMZvzWpgr0ncJi5GB8IeNxxyEU=";
              excludes = [
                "NEWS"
              ];
            })
            # Backport of PHP_LIBXML_IGNORE_DEPRECATIONS_START and PHP_LIBXML_IGNORE_DEPRECATIONS_END
            # Required for libxml2 2.13 compatibility patch.
            ../development/interpreters/php/php81-fix-libxml2-2.13-compatibility.patch
            # Fix build with libxml2 2.13+. Has to be applied after libxml2 2.12 patch.
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/9b4f6b09d58a4e54ee60443bf9a8b166852c03e0.patch";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.2" && lib.versionOlder php.version "8.2.22") [
            # Fixes compatibility with libxml2 2.13. Part of 8.3.10RC1+, 8.2.22RC1+
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/4fe821311cafb18ca8bdf20b9d796c48a13ba552.diff?full_index=1";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.3" && lib.versionOlder php.version "8.3.10") [
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/ecf0bb0fd12132d853969c5e9a212e5f627f2da2.diff?full_index=1";
              hash = "sha256-sodGODHb4l04P0srn3L8l3K+DjZzCsCNbamfkmIyF+k=";
              excludes = [ "NEWS" ];
            })
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
          doCheck = stdenv.isDarwin;  # TODO: a couple tests still fail on *-linux
          internalDeps = [ php.extensions.session ];
          patches = lib.optionals (lib.versions.majorMinor php.version == "8.1") [
            # Fix tests with libxml2 2.12
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/061058a9b1bbd90d27d97d79aebcf2b5029767b0.patch";
              hash = "sha256-0hOlAG+pOYp/gUU0MUMZvzWpgr0ncJi5GB8IeNxxyEU=";
              excludes = [
                "NEWS"
              ];
            })
            # Backport of PHP_LIBXML_IGNORE_DEPRECATIONS_START and PHP_LIBXML_IGNORE_DEPRECATIONS_END
            # Required for libxml2 2.13 compatibility patch.
            ../development/interpreters/php/php81-fix-libxml2-2.13-compatibility.patch
            # Fix build with libxml2 2.13+. Has to be applied after libxml2 2.12 patch.
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/9b4f6b09d58a4e54ee60443bf9a8b166852c03e0.patch";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.2" && lib.versionOlder php.version "8.2.22") [
            # Fixes compatibility with libxml2 2.13. Part of 8.3.10RC1+, 8.2.22RC1+
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/4fe821311cafb18ca8bdf20b9d796c48a13ba552.diff?full_index=1";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.2") [
            # Fix test 'bug55639.phpt'
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/1b52ecd78ad1a211a4a9db65975df34d2539125b.patch";
              hash = "sha256-LVk9sfwl5D+rHzyYjfV4pAuhBjSPXj1WjTfnrzBJXhY";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.3" && lib.versionOlder php.version "8.3.10") [
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/ecf0bb0fd12132d853969c5e9a212e5f627f2da2.diff?full_index=1";
              hash = "sha256-sodGODHb4l04P0srn3L8l3K+DjZzCsCNbamfkmIyF+k=";
              excludes = [ "NEWS" ];
            })
          ];
        }
        {
          name = "sockets";
          doCheck = false;
        }
        { name = "sodium"; buildInputs = [ libsodium ]; }
        {
          name = "sqlite3";
          buildInputs = [ sqlite ];

          # The `sqlite3_bind_bug68849.phpt` test is currently broken for i686 Linux systems since sqlite 3.43, cf.:
          # - https://github.com/php/php-src/issues/12076
          # - https://www.sqlite.org/forum/forumpost/abbb95376ec6cd5f
          patches = lib.optionals (stdenv.isi686 && stdenv.isLinux) [
            ../development/interpreters/php/skip-sqlite3_bind_bug68849.phpt.patch
          ];
        }
        { name = "sysvmsg"; }
        { name = "sysvsem"; }
        { name = "sysvshm"; }
        { name = "tidy"; configureFlags = [ "--with-tidy=${html-tidy}" ]; doCheck = false; }
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
          patches = lib.optionals (lib.versions.majorMinor php.version == "8.1") [
            # Fix tests with libxml2 2.12
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/061058a9b1bbd90d27d97d79aebcf2b5029767b0.patch";
              hash = "sha256-0hOlAG+pOYp/gUU0MUMZvzWpgr0ncJi5GB8IeNxxyEU=";
              excludes = [
                "NEWS"
              ];
            })
            # Backport of PHP_LIBXML_IGNORE_DEPRECATIONS_START and PHP_LIBXML_IGNORE_DEPRECATIONS_END
            # Required for libxml2 2.13 compatibility patch.
            ../development/interpreters/php/php81-fix-libxml2-2.13-compatibility.patch
            # Fix build with libxml2 2.13+. Has to be applied after libxml2 2.12 patch.
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/9b4f6b09d58a4e54ee60443bf9a8b166852c03e0.patch";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.2" && lib.versionOlder php.version "8.2.22") [
            # Fixes compatibility with libxml2 2.13. Part of 8.3.10RC1+, 8.2.22RC1+
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/4fe821311cafb18ca8bdf20b9d796c48a13ba552.diff?full_index=1";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.3" && lib.versionOlder php.version "8.3.10") [
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/ecf0bb0fd12132d853969c5e9a212e5f627f2da2.diff?full_index=1";
              hash = "sha256-sodGODHb4l04P0srn3L8l3K+DjZzCsCNbamfkmIyF+k=";
              excludes = [ "NEWS" ];
            })
          ];
        }
        {
          name = "xmlreader";
          buildInputs = [ libxml2 ];
          internalDeps = [ php.extensions.dom ];
          env.NIX_CFLAGS_COMPILE = toString [ "-I../.." "-DHAVE_DOM" ];
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
          patches = lib.optionals (lib.versions.majorMinor php.version == "8.1") [
            # Fix tests with libxml2 2.12
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/061058a9b1bbd90d27d97d79aebcf2b5029767b0.patch";
              hash = "sha256-0hOlAG+pOYp/gUU0MUMZvzWpgr0ncJi5GB8IeNxxyEU=";
              excludes = [
                "NEWS"
              ];
            })
            # Backport of PHP_LIBXML_IGNORE_DEPRECATIONS_START and PHP_LIBXML_IGNORE_DEPRECATIONS_END
            # Required for libxml2 2.13 compatibility patch.
            ../development/interpreters/php/php81-fix-libxml2-2.13-compatibility.patch
            # Fix build with libxml2 2.13+. Has to be applied after libxml2 2.12 patch.
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/9b4f6b09d58a4e54ee60443bf9a8b166852c03e0.patch";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.2" && lib.versionOlder php.version "8.2.22") [
            # Fixes compatibility with libxml2 2.13. Part of 8.3.10RC1+, 8.2.22RC1+
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/4fe821311cafb18ca8bdf20b9d796c48a13ba552.diff?full_index=1";
              hash = "sha256-YC3I0BQi3o3+VmRu/UqpqPpaSC+ekPqzbORTHftbPvY=";
            })
          ] ++ lib.optionals (lib.versions.majorMinor php.version == "8.3" && lib.versionOlder php.version "8.3.10") [
            (fetchpatch {
              url = "https://github.com/php/php-src/commit/ecf0bb0fd12132d853969c5e9a212e5f627f2da2.diff?full_index=1";
              hash = "sha256-sodGODHb4l04P0srn3L8l3K+DjZzCsCNbamfkmIyF+k=";
              excludes = [ "NEWS" ];
            })
          ];
        }
        {
          name = "xsl";
          buildInputs = [ libxslt libxml2 ];
          internalDeps = [ php.extensions.dom ];
          doCheck = false;
          env.NIX_CFLAGS_COMPILE = toString [ "-I../.." "-DHAVE_DOM" ];
          configureFlags = [ "--with-xsl=${libxslt.dev}" ];
        }
        {
          name = "zend_test";
          internalDeps = [ php.extensions.dom ];
          env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2";
        }
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
          value = mkExtension (builtins.removeAttrs drv [ "enable" ]);
        })
        (builtins.filter (i: i.enable or true) extensionData);

      # Produce the final attribute set of all extensions defined.
    in
    builtins.listToAttrs namedExtensions
  );
})
