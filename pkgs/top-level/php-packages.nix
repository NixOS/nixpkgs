{ stdenv, lib, pkgs, fetchgit, php, phpWithExtensions, autoconf, pkgconfig, re2c
, gettext, bzip2, curl, libxml2, openssl, gmp, icu, oniguruma, libsodium
, html-tidy, libzip, zlib, pcre, pcre2, libxslt, aspell, openldap, cyrus_sasl
, uwimap, pam, libiconv, enchant1, libXpm, gd, libwebp, libjpeg, libpng
, freetype, libffi, freetds, postgresql, sqlite, net-snmp, unixODBC, libedit
, readline, rsync
}:

let
  buildPecl = import ../build-support/build-pecl.nix {
    inherit php lib;
    inherit (pkgs) stdenv autoreconfHook fetchurl re2c;
  };

  # Wrap mkDerivation to prepend pname with "php-" to make names consistent
  # with how buildPecl does it and make the file easier to overview.
  mkDerivation = { pname, ... }@args: pkgs.stdenv.mkDerivation (args // {
    pname = "php-${pname}";
  });

  isPhp73 = pkgs.lib.versionAtLeast php.version "7.3";
  isPhp74 = pkgs.lib.versionAtLeast php.version "7.4";

  pcre' = if (lib.versionAtLeast php.version "7.3") then pcre2 else pcre;
in
{
  inherit buildPecl;

  # This is a set of interactive tools based on PHP.
  packages = {
    box = mkDerivation rec {
      version = "2.7.5";
      pname = "box";

      src = pkgs.fetchurl {
        url = "https://github.com/box-project/box2/releases/download/${version}/box-${version}.phar";
        sha256 = "1zmxdadrv0i2l8cz7xb38gnfmfyljpsaz2nnkjzqzksdmncbgd18";
      };

      phases = [ "installPhase" ];
      buildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out/bin
        install -D $src $out/libexec/box/box.phar
        makeWrapper ${phpWithExtensions}/bin/php $out/bin/box \
          --add-flags "-d phar.readonly=0 $out/libexec/box/box.phar"
      '';

      meta = with pkgs.lib; {
        description = "An application for building and managing Phars";
        license = licenses.mit;
        homepage = "https://box-project.github.io/box2/";
        maintainers = with maintainers; [ jtojnar ];
      };
    };

    composer = mkDerivation rec {
      version = "1.9.3";
      pname = "composer";

      src = pkgs.fetchurl {
        url = "https://getcomposer.org/download/${version}/composer.phar";
        sha256 = "VRZVwvyB9BBlCPQrvEsk6r00sCKxO8Hn2WQr9IPQp9Q=";
      };

      dontUnpack = true;

      nativeBuildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out/bin
        install -D $src $out/libexec/composer/composer.phar
        makeWrapper ${phpWithExtensions}/bin/php $out/bin/composer \
          --add-flags "$out/libexec/composer/composer.phar" \
          --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.unzip ]}
      '';

      meta = with pkgs.lib; {
        description = "Dependency Manager for PHP";
        license = licenses.mit;
        homepage = "https://getcomposer.org/";
        maintainers = with maintainers; [ globin offline ];
      };
    };

    php-cs-fixer = mkDerivation rec {
      version = "2.16.1";
      pname = "php-cs-fixer";

      src = pkgs.fetchurl {
        url = "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${version}/php-cs-fixer.phar";
        sha256 = "1dq1nhy666zg6d4fkfsjwhj1vwh1ncap2c9ljplxv98a9mm6fk68";
      };

      phases = [ "installPhase" ];
      buildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out/bin
        install -D $src $out/libexec/php-cs-fixer/php-cs-fixer.phar
        makeWrapper ${php}/bin/php $out/bin/php-cs-fixer \
          --add-flags "$out/libexec/php-cs-fixer/php-cs-fixer.phar"
      '';

      meta = with pkgs.lib; {
        description = "A tool to automatically fix PHP coding standards issues";
        license = licenses.mit;
        homepage = "http://cs.sensiolabs.org/";
        maintainers = with maintainers; [ jtojnar ];
      };
    };

    php-parallel-lint = mkDerivation rec {
      version = "1.0.0";
      pname = "php-parallel-lint";

      src = pkgs.fetchFromGitHub {
        owner = "JakubOnderka";
        repo = "PHP-Parallel-Lint";
        rev = "v${version}";
        sha256 = "16nv8yyk2z3l213dg067l6di4pigg5rd8yswr5xgd18jwbys2vnw";
      };

      buildInputs = [
        pkgs.makeWrapper
        php.packages.composer
        php.packages.box
      ];

      buildPhase = ''
        composer dump-autoload
        box build
      '';

      installPhase = ''
        mkdir -p $out/bin
        install -D parallel-lint.phar $out/libexec/php-parallel-lint/php-parallel-lint.phar
        makeWrapper ${php}/bin/php $out/bin/php-parallel-lint \
          --add-flags "$out/libexec/php-parallel-lint/php-parallel-lint.phar"
      '';

      meta = with pkgs.lib; {
        description = "This tool check syntax of PHP files faster than serial check with fancier output";
        license = licenses.bsd2;
        homepage = "https://github.com/JakubOnderka/PHP-Parallel-Lint";
        maintainers = with maintainers; [ jtojnar ];
      };
    };

    phpcbf = mkDerivation rec {
      version = "3.5.3";
      pname = "phpcbf";

      src = pkgs.fetchurl {
        url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcbf.phar";
        sha256 = "1mrsf9p6p64pyqyylnlxb2b7cirdfccch83g7yhfnka3znffq86v";
      };

      phases = [ "installPhase" ];
      nativeBuildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out/bin
        install -D $src $out/libexec/phpcbf/phpcbf.phar
        makeWrapper ${php}/bin/php $out/bin/phpcbf \
          --add-flags "$out/libexec/phpcbf/phpcbf.phar"
      '';

      meta = with pkgs.lib; {
        description = "PHP coding standard beautifier and fixer";
        license = licenses.bsd3;
        homepage = "https://squizlabs.github.io/PHP_CodeSniffer/";
        maintainers = with maintainers; [ cmcdragonkai etu ];
      };
    };

    phpcs = mkDerivation rec {
      version = "3.5.3";
      pname = "phpcs";

      src = pkgs.fetchurl {
        url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
        sha256 = "0y4nhsifj4pdmf5g1nnm4951yjgiqswyz7wmjxx6kqiqc7chlkml";
      };

      phases = [ "installPhase" ];
      buildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out/bin
        install -D $src $out/libexec/phpcs/phpcs.phar
        makeWrapper ${php}/bin/php $out/bin/phpcs \
          --add-flags "$out/libexec/phpcs/phpcs.phar"
      '';

      meta = with pkgs.lib; {
        description = "PHP coding standard tool";
        license = licenses.bsd3;
        homepage = "https://squizlabs.github.io/PHP_CodeSniffer/";
        maintainers = with maintainers; [ javaguirre etu ];
      };
    };

    phpstan = mkDerivation rec {
      version = "0.12.14";
      pname = "phpstan";

      src = pkgs.fetchurl {
        url = "https://github.com/phpstan/phpstan/releases/download/${version}/phpstan.phar";
        sha256 = "JAq1/+bVhTgKRR7oFusqZ/yBOYewaOM38ZoiCjirsTg=";
      };

      phases = [ "installPhase" ];
      nativeBuildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out/bin
        install -D $src $out/libexec/phpstan/phpstan.phar
        makeWrapper ${php}/bin/php $out/bin/phpstan \
          --add-flags "$out/libexec/phpstan/phpstan.phar"
      '';

      meta = with pkgs.lib; {
        description = "PHP Static Analysis Tool";
        longDescription = ''
        PHPStan focuses on finding errors in your code without actually running
        it. It catches whole classes of bugs even before you write tests for the
        code. It moves PHP closer to compiled languages in the sense that the
        correctness of each line of the code can be checked before you run the
        actual line.
      '';
        license = licenses.mit;
        homepage = "https://github.com/phpstan/phpstan";
        maintainers = with maintainers; [ etu ];
      };
    };

    psalm = mkDerivation rec {
      version = "3.9.3";
      pname = "psalm";

      src = pkgs.fetchurl {
        url = "https://github.com/vimeo/psalm/releases/download/${version}/psalm.phar";
        sha256 = "KHm2n06y/yxN5B2rCVxT5ja7HxkyxAMsjZ5HLb3xr4M=";
      };

      phases = [ "installPhase" ];
      nativeBuildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out/bin
        install -D $src $out/libexec/psalm/psalm.phar
        makeWrapper ${php}/bin/php $out/bin/psalm \
          --add-flags "$out/libexec/psalm/psalm.phar"
      '';

      meta = with pkgs.lib; {
        description = "A static analysis tool for finding errors in PHP applications";
        license = licenses.mit;
        homepage = "https://github.com/vimeo/psalm";
      };
    };

    psysh = mkDerivation rec {
      version = "0.9.12";
      pname = "psysh";

      src = pkgs.fetchurl {
        url = "https://github.com/bobthecow/psysh/releases/download/v${version}/psysh-v${version}.tar.gz";
        sha256 = "0bzmc94li481xk81gv460ipq9zl03skbnq8m3rnw34i2c04hxczc";
      };

      phases = [ "installPhase" ];
      nativeBuildInputs = [ pkgs.makeWrapper ];

      installPhase = ''
        mkdir -p $out/bin
        tar -xzf $src -C $out/bin
        chmod +x $out/bin/psysh
        wrapProgram $out/bin/psysh
      '';

      meta = with pkgs.lib; {
        description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
        license = licenses.mit;
        homepage = "https://psysh.org/";
        maintainers = with maintainers; [ caugner ];
      };
    };
  };



  # This is a set of PHP extensions meant to be used in php.buildEnv
  # or php.withExtensions to extend the functionality of the PHP
  # interpreter.
  extensions = {
    apcu = buildPecl {
      version = "5.1.18";
      pname = "apcu";

      sha256 = "0ayykd4hfvdzk7qnr5k6yq5scwf6rb2i05xscfv76q5dmkkynvfl";

      buildInputs = [ pcre' ];
      doCheck = true;
      checkTarget = "test";
      checkFlagsArray = ["REPORT_EXIT_STATUS=1" "NO_INTERACTION=1"];
      makeFlags = [ "phpincludedir=$(dev)/include" ];
      outputs = [ "out" "dev" ];
    };

    apcu_bc = buildPecl {
      version = "1.0.5";
      pname = "apcu_bc";

      sha256 = "0ma00syhk2ps9k9p02jz7rii6x3i2p986il23703zz5npd6y9n20";

      buildInputs = [
        php.extensions.apcu
        pcre'
      ];
    };

    ast = buildPecl {
      version = "1.0.5";
      pname = "ast";

      sha256 = "16c5isldm4csjbcvz1qk2mmrhgvh24sxsp6w6f5a37xpa3vciawp";
    };

    couchbase = buildPecl rec {
      version = "2.6.1";
      pname = "couchbase";

      buildInputs = [
        pkgs.libcouchbase
        pkgs.zlib
        php.extensions.igbinary
        php.extensions.pcs
      ];

      src = pkgs.fetchFromGitHub {
        owner = "couchbase";
        repo = "php-couchbase";
        rev = "v${version}";
        sha256 = "0jdzgcvab1vpxai23brmmvizjjq2d2dik9aklz6bzspfb512qjd6";
      };

      configureFlags = [ "--with-couchbase" ];
      internalDeps = [ php.extensions.json ];
      patches = [
        (pkgs.writeText "php-couchbase.patch" ''
          --- a/config.m4
          +++ b/config.m4
          @@ -9,7 +9,7 @@ if test "$PHP_COUCHBASE" != "no"; then
               LIBCOUCHBASE_DIR=$PHP_COUCHBASE
             else
               AC_MSG_CHECKING(for libcouchbase in default path)
          -    for i in /usr/local /usr; do
          +    for i in ${pkgs.libcouchbase}; do
                 if test -r $i/include/libcouchbase/couchbase.h; then
                   LIBCOUCHBASE_DIR=$i
                   AC_MSG_RESULT(found in $i)
          @@ -154,6 +154,8 @@ COUCHBASE_FILES=" \
               igbinary_inc_path="$phpincludedir"
             elif test -f "$phpincludedir/ext/igbinary/igbinary.h"; then
               igbinary_inc_path="$phpincludedir"
          +  elif test -f "${php.extensions.igbinary.dev}/include/ext/igbinary/igbinary.h"; then
          +    igbinary_inc_path="${php.extensions.igbinary.dev}/include"
             fi
             if test "$igbinary_inc_path" = ""; then
               AC_MSG_WARN([Cannot find igbinary.h])
        '')
      ];

      meta.broken = isPhp74; # Build error
    };

    event = buildPecl {
      version = "2.5.3";
      pname = "event";

      sha256 = "12liry5ldvgwp1v1a6zgfq8w6iyyxmsdj4c71bp157nnf58cb8hb";

      configureFlags = [
        "--with-event-libevent-dir=${pkgs.libevent.dev}"
        "--with-event-core"
        "--with-event-extra"
        "--with-event-pthreads"
      ];

      postPhpize = ''
        substituteInPlace configure --replace 'as_fn_error $? "Couldn'\'''t find $phpincludedir/sockets/php_sockets.h. Please check if sockets extension installed" "$LINENO" 5' \
                                              ':'
      '';

      nativeBuildInputs = [ pkgs.pkgconfig ];
      buildInputs = with pkgs; [ openssl libevent ];
      internalDeps = [ php.extensions.sockets ];

      meta = with pkgs.lib; {
        description = ''
          This is an extension to efficiently schedule I/O, time and signal based
          events using the best I/O notification mechanism available for specific platform.
        '';
        license = licenses.php301;
        homepage = "https://bitbucket.org/osmanov/pecl-event/";
      };
    };

    igbinary = buildPecl {
      version = "3.0.1";
      pname = "igbinary";

      sha256 = "1w8jmf1qpggdvq0ndfi86n7i7cqgh1s8q6hys2lijvi37rzn0nar";

      configureFlags = [ "--enable-igbinary" ];
      makeFlags = [ "phpincludedir=$(dev)/include" ];
      outputs = [ "out" "dev" ];
    };

    imagick = buildPecl {
      version = "3.4.4";
      pname = "imagick";

      sha256 = "0xvhaqny1v796ywx83w7jyjyd0nrxkxf34w9zi8qc8aw8qbammcd";

      configureFlags = [ "--with-imagick=${pkgs.imagemagick.dev}" ];
      nativeBuildInputs = [ pkgs.pkgconfig ];
      buildInputs = [ pcre' ];
    };

    mailparse = buildPecl {
      version = "3.0.3";
      pname = "mailparse";
      sha256 = "00nk14jbdbln93mx3ag691avc11ff94hkadrcv5pn51c6ihsxbmz";

      internalDeps = [ php.extensions.mbstring ];
      postConfigure = ''
        echo "#define HAVE_MBSTRING 1" >> config.h
      '';
    };

    maxminddb = buildPecl rec {
      pname = "maxminddb";
      version = "1.6.0";

      src = pkgs.fetchFromGitHub {
        owner = "maxmind";
        repo = "MaxMind-DB-Reader-php";
        rev = "v${version}";
        sha256 = "0sa943ij9pgz55aik93lllb8lh063bvr66ibn77p3y3p41vdiabz";
      };

      buildInputs = [ pkgs.libmaxminddb ];
      sourceRoot = "source/ext";

      meta = with pkgs.lib; {
        description = "C extension that is a drop-in replacement for MaxMind\\Db\\Reader";
        license = with licenses; [ asl20 ];
        maintainers = with maintainers; [ ajs124 das_j ];
      };
    };

    memcached = buildPecl rec {
      version = "3.1.5";
      pname = "memcached";

      src = fetchgit {
        url = "https://github.com/php-memcached-dev/php-memcached";
        rev = "v${version}";
        sha256 = "01mbh2m3kfbdvih3c8g3g9h4vdd80r0i9g2z8b3lx3mi8mmcj380";
      };

      internalDeps = [
        php.extensions.session
      ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
        php.extensions.hash
      ];

      configureFlags = [
        "--with-zlib-dir=${pkgs.zlib.dev}"
        "--with-libmemcached-dir=${pkgs.libmemcached}"
      ];

      nativeBuildInputs = [ pkgs.pkgconfig ];
      buildInputs = with pkgs; [ cyrus_sasl zlib ];
    };

    mongodb = buildPecl {
      pname = "mongodb";
      version = "1.6.1";

      sha256 = "1j1w4n33347j9kwvxwsrix3gvjbiqcn1s5v59pp64s536cci8q0m";

      nativeBuildInputs = [ pkgs.pkgconfig ];
      buildInputs = with pkgs; [
        cyrus_sasl
        icu
        openssl
        snappy
        zlib
        pcre'
      ] ++ lib.optional (pkgs.stdenv.isDarwin) pkgs.darwin.apple_sdk.frameworks.Security;
    };

    oci8 = buildPecl {
      version = "2.2.0";
      pname = "oci8";

      sha256 = "0jhivxj1nkkza4h23z33y7xhffii60d7dr51h1czjk10qywl7pyd";
      buildInputs = [ pkgs.oracle-instantclient ];
      configureFlags = [ "--with-oci8=shared,instantclient,${pkgs.oracle-instantclient.lib}/lib" ];

      postPatch = ''
        sed -i -e 's|OCISDKMANINC=`.*$|OCISDKMANINC="${pkgs.oracle-instantclient.dev}/include"|' config.m4
      '';
    };

    pcov = buildPecl {
      version = "1.0.6";
      pname = "pcov";

      sha256 = "1psfwscrc025z8mziq69pcx60k4fbkqa5g2ia8lplb94mmarj0v1";

      buildInputs = [ pcre' ];
    };

    pcs = buildPecl {
      version = "1.3.3";
      pname = "pcs";

      sha256 = "0d4p1gpl8gkzdiv860qzxfz250ryf0wmjgyc8qcaaqgkdyh5jy5p";

      meta.broken = isPhp74; # Build error
    };

    pdo_oci = buildPecl rec {
      inherit (php) src version;

      pname = "pdo_oci";
      sourceRoot = "php-${version}/ext/pdo_oci";

      buildInputs = [ pkgs.oracle-instantclient ];
      configureFlags = [ "--with-pdo-oci=instantclient,${pkgs.oracle-instantclient.lib}/lib" ];

      internalDeps = [ php.extensions.pdo ];

      postPatch = ''
      sed -i -e 's|OCISDKMANINC=`.*$|OCISDKMANINC="${pkgs.oracle-instantclient.dev}/include"|' config.m4
    '';
    };

    pdo_sqlsrv = buildPecl {
      version = "5.8.0";
      pname = "pdo_sqlsrv";

      sha256 = "0z4vbyd851b4jr6p69l2ylk91iihndsm2qjb429pxcv8g6dqzqll";

      internalDeps = [ php.extensions.pdo ];

      buildInputs = [ pkgs.unixODBC ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.libiconv ];
    };

    php_excel = buildPecl rec {
      version = "1.0.2";
      pname = "php_excel";
      phpVersion = "php7";

      buildInputs = [ pkgs.libxl ];

      src = pkgs.fetchurl {
        url = "https://github.com/iliaal/php_excel/releases/download/Excel-1.0.2-PHP7/excel-${version}-${phpVersion}.tgz";
        sha256 = "0dpvih9gpiyh1ml22zi7hi6kslkilzby00z1p8x248idylldzs2n";
      };

      configureFlags = [ "--with-excel" "--with-libxl-incdir=${pkgs.libxl}/include_c" "--with-libxl-libdir=${pkgs.libxl}/lib" ];
    };

    pinba = let
      version = if isPhp73 then "1.1.2-dev" else "1.1.1";
      src = pkgs.fetchFromGitHub ({
        owner = "tony2001";
        repo = "pinba_extension";
      } // (if (isPhp73) then {
        rev = "edbc313f1b4fb8407bf7d5acf63fbb0359c7fb2e";
        sha256 = "02sljqm6griw8ccqavl23f7w1hp2zflcv24lpf00k6pyrn9cwx80";
      } else {
        rev = "RELEASE_1_1_1";
        sha256 = "1kdp7vav0y315695vhm3xifgsh6h6y6pny70xw3iai461n58khj5";
      }));
    in buildPecl {
      pname = "pinba";
      inherit version src;

      meta = with pkgs.lib; {
        description = "PHP extension for Pinba";
        longDescription = ''
          Pinba is a MySQL storage engine that acts as a realtime monitoring and
          statistics server for PHP using MySQL as a read-only interface.
        '';
        homepage = "http://pinba.org/";
      };
    };

    protobuf = buildPecl {
      version = "3.11.2";
      pname = "protobuf";

      sha256 = "0bhdykdyk58ywqj940zb7jyvrlgdr6hdb4s8kn79fz3p0i79l9hz";

      buildInputs = with pkgs; [ pcre' ];

      meta = with pkgs.lib; {
        description = ''
          Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data.
        '';
        license = licenses.bsd3;
        homepage = "https://developers.google.com/protocol-buffers/";
      };
    };

    pthreads = let
      version = "3.2.0";
      src = pkgs.fetchFromGitHub ({
        owner = "krakjoe";
        repo = "pthreads";
      } // (if (isPhp73) then {
        rev = "4d1c2483ceb459ea4284db4eb06646d5715e7154";
        sha256 = "07kdxypy0bgggrfav2h1ccbv67lllbvpa3s3zsaqci0gq4fyi830";
      } else {
        rev = "v3.2.0";
        sha256 = "17hypm75d4w7lvz96jb7s0s87018yzmmap0l125d5fd7abnhzfvv";
      }));
    in buildPecl {
      pname = "pthreads";
      inherit version src;

      buildInputs = [ pcre'.dev ];

      meta.broken = isPhp74;
    };

    redis = buildPecl {
      version = "5.1.1";
      pname = "redis";

      sha256 = "1041zv91fkda73w4c3pj6zdvwjgb3q7mxg6mwnq9gisl80mrs732";

      internalDeps = with php.extensions; [
        json
        session
      ] ++ lib.optionals (lib.versionOlder php.version "7.4") [
        hash ];
    };

    sqlsrv = buildPecl {
      version = "5.8.0";
      pname = "sqlsrv";

      sha256 = "1kv4krk1w4hri99b0sdgwgy9c4y0yh217wx2y3irhkfi46kdrjnw";

      buildInputs = [ pkgs.unixODBC ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.libiconv ];
    };

    v8 = buildPecl {
      version = "0.2.2";
      pname = "v8";

      sha256 = "103nys7zkpi1hifqp9miyl0m1mn07xqshw3sapyz365nb35g5q71";

      buildInputs = [ pkgs.v8_6_x ];
      configureFlags = [ "--with-v8=${pkgs.v8_6_x}" ];
      meta.broken = true;
    };

    v8js = buildPecl {
      version = "2.1.0";
      pname = "v8js";

      sha256 = "0g63dyhhicngbgqg34wl91nm3556vzdgkq19gy52gvmqj47rj6rg";

      buildInputs = [ pkgs.v8_6_x ];
      configureFlags = [ "--with-v8js=${pkgs.v8_6_x}" ];
      meta.broken = true;
    };

    xdebug = buildPecl {
      version = "2.8.1";
      pname = "xdebug";

      sha256 = "080mwr7m72rf0jsig5074dgq2n86hhs7rdbfg6yvnm959sby72w3";

      doCheck = true;
      checkTarget = "test";

      zendExtension = true;
    };

    yaml = buildPecl {
      version = "2.0.4";
      pname = "yaml";

      sha256 = "1036zhc5yskdfymyk8jhwc34kvkvsn5kaf50336153v4dqwb11lp";

      configureFlags = [
        "--with-yaml=${pkgs.libyaml}"
      ];

      nativeBuildInputs = [ pkgs.pkgconfig ];
    };

    zmq = buildPecl {
      version = "1.1.3";
      pname = "zmq";

      sha256 = "1kj487vllqj9720vlhfsmv32hs2dy2agp6176mav6ldx31c3g4n4";

      configureFlags = [
        "--with-zmq=${pkgs.zeromq}"
      ];

      nativeBuildInputs = [ pkgs.pkgconfig ];

      meta.broken = isPhp73;
    };
  } // (let
    # Function to build a single php extension based on the php version.
    #
    # Name passed is the name of the extension and is automatically used
    # to add the configureFlag "--enable-${name}", which can be overriden.
    #
    # Build inputs is used for extra deps that may be needed. And zendExtension
    # will mark the extension as a zend extension or not.
    mkExtension = {
      name
      , configureFlags ? [ "--enable-${name}" ]
      , internalDeps ? []
      , postPhpize ? ""
      , buildInputs ? []
      , zendExtension ? false
      , doCheck ? true
      , ...
    }@args: stdenv.mkDerivation ((builtins.removeAttrs args [ "name" ]) // {
      pname = "php-${name}";
      extensionName = name;

      inherit (php) version src;
      sourceRoot = "php-${php.version}/ext/${name}";

      enableParallelBuilding = true;
      nativeBuildInputs = [ php autoconf pkgconfig re2c ];
      inherit configureFlags internalDeps buildInputs
        zendExtension doCheck;

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
        ${lib.concatMapStringsSep "\n"
          (dep: "mkdir -p ext; ln -s ${dep.dev}/include ext/${dep.extensionName}")
          internalDeps}
      '';
      checkPhase = "echo n | make test";
      outputs = [ "out" "dev" ];
      installPhase = ''
        mkdir -p $out/lib/php/extensions
        cp modules/${name}.so $out/lib/php/extensions/${name}.so
        mkdir -p $dev/include
        ${rsync}/bin/rsync -r --filter="+ */" \
                              --filter="+ *.h" \
                              --filter="- *" \
                              --prune-empty-dirs \
                              . $dev/include/
      '';
    });

    # This list contains build instructions for different modules that one may
    # want to build.
    #
    # These will be passed as arguments to mkExtension above.
    extensionData = [
      { name = "bcmath"; }
      { name = "bz2"; buildInputs = [ bzip2 ]; configureFlags = [ "--with-bz2=${bzip2.dev}" ]; }
      { name = "calendar"; }
      { name = "ctype"; }
      { name = "curl";
        buildInputs = [ curl ];
        configureFlags = [ "--with-curl=${curl.dev}" ];
        doCheck = false; }
      { name = "dba"; }
      { name = "dom";
        buildInputs = [ libxml2 ];
        configureFlags = [ "--enable-dom" ]
          # Required to build on darwin.
          ++ lib.optional (lib.versionOlder php.version "7.4") [ "--with-libxml-dir=${libxml2.dev}" ]; }
      { name = "enchant";
        buildInputs = [ enchant1 ];
        configureFlags = [ "--with-enchant=${enchant1}" ];
        # enchant1 doesn't build on darwin.
        enable = (!stdenv.isDarwin);
        doCheck = false; }
      { name = "exif"; doCheck = false; }
      { name = "ffi"; buildInputs = [ libffi ]; enable = lib.versionAtLeast php.version "7.4"; }
      { name = "fileinfo"; buildInputs = [ pcre' ]; }
      { name = "filter"; buildInputs = [ pcre' ]; }
      { name = "ftp"; buildInputs = [ openssl ]; }
      { name = "gd";
        buildInputs = [ zlib gd ];
        configureFlags = [
          "--enable-gd"
          "--with-external-gd=${gd.dev}"
          "--enable-gd-jis-conv"
        ];
        doCheck = false;
        enable = lib.versionAtLeast php.version "7.4"; }
      { name = "gd";
        buildInputs = [ zlib gd libXpm ];
        configureFlags = [
          "--with-gd=${gd.dev}"
          "--with-freetype-dir=${freetype.dev}"
          "--with-jpeg-dir=${libjpeg.dev}"
          "--with-png-dir=${libpng.dev}"
          "--with-webp-dir=${libwebp}"
          "--with-xpm-dir=${libXpm.dev}"
          "--with-zlib-dir=${zlib.dev}"
          "--enable-gd-jis-conv"
        ];
        doCheck = false;
        enable = lib.versionOlder php.version "7.4"; }
      { name = "gettext";
        buildInputs = [ gettext ];
        postPhpize = ''substituteInPlace configure --replace 'as_fn_error $? "Cannot locate header file libintl.h" "$LINENO" 5' ':' '';
        configureFlags = "--with-gettext=${gettext}"; }
      { name = "gmp";
        buildInputs = [ gmp ];
        configureFlags = [ "--with-gmp=${gmp.dev}" ]; }
      { name = "hash"; enable = lib.versionOlder php.version "7.4"; }
      { name = "iconv";
        configureFlags = if stdenv.isDarwin then
                           [ "--with-iconv=${libiconv}" ]
                         else
                           [ "--with-iconv" ];
        doCheck = false; }
      { name = "imap";
        buildInputs = [ uwimap openssl pam pcre' ];
        configureFlags = [ "--with-imap=${uwimap}" "--with-imap-ssl" ];
        # uwimap doesn't build on darwin.
        enable = (!stdenv.isDarwin); }
      # interbase (7.3, 7.2)
      { name = "intl"; buildInputs = [ icu ]; }
      { name = "json"; }
      { name = "ldap";
        buildInputs = [ openldap cyrus_sasl ];
        configureFlags = [
          "--with-ldap"
          "LDAP_DIR=${openldap.dev}"
          "LDAP_INCDIR=${openldap.dev}/include"
          "LDAP_LIBDIR=${openldap.out}/lib"
        ] ++ lib.optional stdenv.isLinux "--with-ldap-sasl=${cyrus_sasl.dev}";
        doCheck = false; }
      { name = "mbstring"; buildInputs = [ oniguruma ]; doCheck = false; }
      { name = "mysqli";
        internalDeps = [ php.extensions.mysqlnd ];
        configureFlags = [ "--with-mysqli=mysqlnd" "--with-mysql-sock=/run/mysqld/mysqld.sock" ];
        doCheck = false; }
      { name = "mysqlnd";
        buildInputs = [ zlib openssl ];
        # The configure script doesn't correctly add library link
        # flags, so we add them to the variable used by the Makefile
        # when linking.
        MYSQLND_SHARED_LIBADD = "-lssl -lcrypto -lz";
        # The configure script builds a config.h which is never
        # included. Let's include it in the main header file
        # included by all .c-files.
        patches = [
          (pkgs.writeText "mysqlnd_config.patch" ''
            --- a/mysqlnd.h
            +++ b/mysqlnd.h
            @@ -1,3 +1,6 @@
            +#ifdef HAVE_CONFIG_H
            +#include "config.h"
            +#endif
             /*
               +----------------------------------------------------------------------+
               | Copyright (c) The PHP Group                                          |
          '')
        ];
        postPhpize = lib.optionalString (lib.versionOlder php.version "7.4") ''
          substituteInPlace configure --replace '$OPENSSL_LIBDIR' '${openssl}/lib' \
                                      --replace '$OPENSSL_INCDIR' '${openssl.dev}/include'
        ''; }
      # oci8 (7.4, 7.3, 7.2)
      # odbc (7.4, 7.3, 7.2)
      { name = "opcache";
        buildInputs = [ pcre' ];
        # HAVE_OPCACHE_FILE_CACHE is defined in config.h, which is
        # included from ZendAccelerator.h, but ZendAccelerator.h is
        # included after the ifdef...
        patches = lib.optional (lib.versionOlder php.version "7.4") [
          (pkgs.writeText "zend_file_cache_config.patch" ''
            --- a/zend_file_cache.c
            +++ b/zend_file_cache.c
            @@ -27,9 +27,9 @@
             #include "ext/standard/md5.h"
             #endif

            +#include "ZendAccelerator.h"
             #ifdef HAVE_OPCACHE_FILE_CACHE

            -#include "ZendAccelerator.h"
             #include "zend_file_cache.h"
             #include "zend_shared_alloc.h"
             #include "zend_accelerator_util_funcs.h"
          '') ];
        zendExtension = true;
        doCheck = !(lib.versionOlder php.version "7.4"); }
      { name = "openssl";
        buildInputs = [ openssl ];
        configureFlags = [ "--with-openssl" ];
        doCheck = false; }
      { name = "pcntl"; }
      { name = "pdo"; doCheck = false; }
      { name = "pdo_dblib";
        internalDeps = [ php.extensions.pdo ];
        configureFlags = [ "--with-pdo-dblib=${freetds}" ];
        # Doesn't seem to work on darwin.
        enable = (!stdenv.isDarwin);
        doCheck = false; }
      # pdo_firebird (7.4, 7.3, 7.2)
      { name = "pdo_mysql";
        internalDeps = with php.extensions; [ pdo mysqlnd ];
        configureFlags = [ "--with-pdo-mysql=mysqlnd" "PHP_MYSQL_SOCK=/run/mysqld/mysqld.sock" ];
        doCheck = false; }
      # pdo_oci (7.4, 7.3, 7.2)
      { name = "pdo_odbc";
        internalDeps = [ php.extensions.pdo ];
        configureFlags = [ "--with-pdo-odbc=unixODBC,${unixODBC}" ];
        doCheck = false; }
      { name = "pdo_pgsql";
        internalDeps = [ php.extensions.pdo ];
        configureFlags = [ "--with-pdo-pgsql=${postgresql}" ];
        doCheck = false; }
      { name = "pdo_sqlite";
        internalDeps = [ php.extensions.pdo ];
        buildInputs = [ sqlite ];
        configureFlags = [ "--with-pdo-sqlite=${sqlite.dev}" ];
        doCheck = false; }
      { name = "pgsql";
        buildInputs = [ pcre' ];
        configureFlags = [ "--with-pgsql=${postgresql}" ];
        doCheck = false; }
      { name = "posix"; doCheck = false; }
      { name = "pspell"; configureFlags = [ "--with-pspell=${aspell}" ]; }
      { name = "readline";
        buildInputs = [ libedit readline ];
        configureFlags = [ "--with-readline=${readline.dev}" ];
        postPhpize = lib.optionalString (lib.versionOlder php.version "7.4") ''
          substituteInPlace configure --replace 'as_fn_error $? "Please reinstall libedit - I cannot find readline.h" "$LINENO" 5' ':'
        '';
        doCheck = false;
      }
      # recode (7.3, 7.2)
      { name = "session"; }
      { name = "shmop"; }
      { name = "simplexml";
        buildInputs = [ libxml2 pcre' ];
        configureFlags = [ "--enable-simplexml" ]
          # Required to build on darwin.
          ++ lib.optional (lib.versionOlder php.version "7.4") [ "--with-libxml-dir=${libxml2.dev}" ]; }
      { name = "snmp";
        buildInputs = [ net-snmp openssl ];
        configureFlags = [ "--with-snmp" ];
        # net-snmp doesn't build on darwin.
        enable = (!stdenv.isDarwin);
        doCheck = false; }
      { name = "soap";
        buildInputs = [ libxml2 ];
        configureFlags = [ "--enable-soap" ]
          # Required to build on darwin.
          ++ lib.optional (lib.versionOlder php.version "7.4") [ "--with-libxml-dir=${libxml2.dev}" ];
        doCheck = false; }
      { name = "sockets"; doCheck = false; }
      { name = "sodium"; buildInputs = [ libsodium ]; }
      { name = "sqlite3"; buildInputs = [ sqlite ]; }
      { name = "sysvmsg"; }
      { name = "sysvsem"; }
      { name = "sysvshm"; }
      { name = "tidy"; configureFlags = [ "--with-tidy=${html-tidy}" ]; doCheck = false; }
      { name = "tokenizer"; }
      { name = "wddx";
        buildInputs = [ libxml2 ];
        internalDeps = [ php.extensions.session ];
        configureFlags = [ "--enable-wddx" "--with-libxml-dir=${libxml2.dev}" ];
        # Removed in php 7.4.
        enable = lib.versionOlder php.version "7.4"; }
      { name = "xml";
        buildInputs = [ libxml2 ];
        configureFlags = [ "--enable-xml" ]
          # Required to build on darwin.
          ++ lib.optional (lib.versionOlder php.version "7.4") [ "--with-libxml-dir=${libxml2.dev}" ];
        doCheck = false; }
      { name = "xmlreader";
        buildInputs = [ libxml2 ];
        configureFlags = [ "--enable-xmlreader CFLAGS=-I../.." ]
          # Required to build on darwin.
          ++ lib.optional (lib.versionOlder php.version "7.4") [ "--with-libxml-dir=${libxml2.dev}" ]; }
      { name = "xmlrpc";
        buildInputs = [ libxml2 libiconv ];
        configureFlags = [ "--with-xmlrpc" ]
          # Required to build on darwin.
          ++ lib.optional (lib.versionOlder php.version "7.4") [ "--with-libxml-dir=${libxml2.dev}" ]; }
      { name = "xmlwriter";
        buildInputs = [ libxml2 ];
        configureFlags = [ "--enable-xmlwriter" ]
          # Required to build on darwin.
          ++ lib.optional (lib.versionOlder php.version "7.4") [ "--with-libxml-dir=${libxml2.dev}" ]; }
      { name = "xsl";
        buildInputs = [ libxslt libxml2 ];
        doCheck = !(lib.versionOlder php.version "7.4");
        configureFlags = [ "--with-xsl=${libxslt.dev}" ]; }
      { name = "zend_test"; }
      { name = "zip";
        buildInputs = [ libzip pcre' ];
        configureFlags = [ "--with-zip" ]
          ++ lib.optional (lib.versionOlder php.version "7.4") [ "--with-zlib-dir=${zlib.dev}" ]
          ++ lib.optional (lib.versionOlder php.version "7.3") [ "--with-libzip" ];
        doCheck = false; }
      { name = "zlib";
        buildInputs = [ zlib ];
        configureFlags = [ "--with-zlib" ]
          ++ lib.optional (lib.versionOlder php.version "7.4") [ "--with-zlib-dir=${zlib.dev}" ]; }
    ];

    # Convert the list of attrs:
    # [ { name = <name>; ... } ... ]
    # to a list of
    # [ { name = <name>; value = <extension drv>; } ... ]
    #
    # which we later use listToAttrs to make all attrs available by name.
    #
    # Also filter out extensions based on the enable property.
    namedExtensions = builtins.map (drv: {
      name = drv.name;
      value = mkExtension drv;
    }) (builtins.filter (i: i.enable or true) extensionData);

    # Produce the final attribute set of all extensions defined.
  in builtins.listToAttrs namedExtensions);
}
