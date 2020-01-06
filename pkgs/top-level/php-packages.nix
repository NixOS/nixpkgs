{ pkgs, fetchgit, php }:

let
  self = with self; {
    buildPecl = import ../build-support/build-pecl.nix {
      inherit php;
      inherit (pkgs) stdenv autoreconfHook fetchurl re2c;
    };

    # Wrap mkDerivation to prepend pname with "php-" to make names consistent
    # with how buildPecl does it and make the file easier to overview.
    mkDerivation = { pname, ... }@args: pkgs.stdenv.mkDerivation (args // {
      pname = "php-${pname}";
    });

  isPhp73 = pkgs.lib.versionAtLeast php.version "7.3";
  isPhp74 = pkgs.lib.versionAtLeast php.version "7.4";

  apcu = buildPecl {
    version = "5.1.18";
    pname = "apcu";

    sha256 = "0ayykd4hfvdzk7qnr5k6yq5scwf6rb2i05xscfv76q5dmkkynvfl";

    buildInputs = [ (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
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

    buildInputs = [ apcu (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
  };

  ast = buildPecl {
    version = "1.0.5";
    pname = "ast";

    sha256 = "16c5isldm4csjbcvz1qk2mmrhgvh24sxsp6w6f5a37xpa3vciawp";
  };

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
      makeWrapper ${php}/bin/php $out/bin/box \
        --add-flags "-d phar.readonly=0 $out/libexec/box/box.phar"
    '';

    meta = with pkgs.lib; {
      description = "An application for building and managing Phars";
      license = licenses.mit;
      homepage = https://box-project.github.io/box2/;
      maintainers = with maintainers; [ jtojnar ];
    };
  };

  composer = mkDerivation rec {
    version = "1.9.1";
    pname = "composer";

    src = pkgs.fetchurl {
      url = "https://getcomposer.org/download/${version}/composer.phar";
      sha256 = "04a1fqxhxrckgxw9xbx7mplkzw808k2dz4jqsxq2dy7w6y80n88z";
    };

    dontUnpack = true;

    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin
      install -D $src $out/libexec/composer/composer.phar
      makeWrapper ${php}/bin/php $out/bin/composer \
        --add-flags "$out/libexec/composer/composer.phar" \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.unzip ]}
    '';

    meta = with pkgs.lib; {
      description = "Dependency Manager for PHP";
      license = licenses.mit;
      homepage = https://getcomposer.org/;
      maintainers = with maintainers; [ globin offline ];
    };
  };

  couchbase = buildPecl rec {
    version = "2.6.1";
    pname = "couchbase";

    buildInputs = [ pkgs.libcouchbase pkgs.zlib igbinary pcs ];

    src = pkgs.fetchFromGitHub {
      owner = "couchbase";
      repo = "php-couchbase";
      rev = "v${version}";
      sha256 = "0jdzgcvab1vpxai23brmmvizjjq2d2dik9aklz6bzspfb512qjd6";
    };

    configureFlags = [ "--with-couchbase" ];

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
        +  elif test -f "${igbinary.dev}/include/ext/igbinary/igbinary.h"; then
        +    igbinary_inc_path="${igbinary.dev}/include"
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
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with pkgs; [ openssl libevent ];

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
    buildInputs = [ (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
  };

  mailparse = buildPecl {
    version = "3.0.3";
    pname = "mailparse";

    sha256 = "00nk14jbdbln93mx3ag691avc11ff94hkadrcv5pn51c6ihsxbmz";
  };

  maxminddb = buildPecl rec {
    pname = "maxminddb";
    version = "1.5.0";

    src = pkgs.fetchFromGitHub {
      owner = "maxmind";
      repo = "MaxMind-DB-Reader-php";
      rev = "v${version}";
      sha256 = "1ilgpx36rgihjr8s4bvkbms5hl6xy7mymna3ym2bl4lb15vkr0sm";
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
      (if isPhp73 then pcre2 else pcre)
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

    buildInputs = [ (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
  };

  pcs = buildPecl {
    version = "1.3.3";
    pname = "pcs";

    sha256 = "0d4p1gpl8gkzdiv860qzxfz250ryf0wmjgyc8qcaaqgkdyh5jy5p";

    meta.broken = isPhp74; # Build error
  };

  pdo_sqlsrv = buildPecl {
    version = "5.6.1";
    pname = "pdo_sqlsrv";

    sha256 = "02ill1iqffa5fha9iz4y91823scml24ikfk8pn90jyycfwv07x6a";

    buildInputs = [ pkgs.unixODBC ];

    meta.broken = isPhp74; # Build error
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
      homepage = http://cs.sensiolabs.org/;
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

    buildInputs = [ pkgs.makeWrapper composer box ];

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
      homepage = https://github.com/JakubOnderka/PHP-Parallel-Lint;
      maintainers = with maintainers; [ jtojnar ];
    };
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
    meta.broken = true;
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
      homepage = https://squizlabs.github.io/PHP_CodeSniffer/;
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
      homepage = https://squizlabs.github.io/PHP_CodeSniffer/;
      maintainers = with maintainers; [ javaguirre etu ];
    };
  };

  phpstan = mkDerivation rec {
    version = "0.12.4";
    pname = "phpstan";

    src = pkgs.fetchurl {
      url = "https://github.com/phpstan/phpstan/releases/download/${version}/phpstan.phar";
      sha256 = "1h386zsbfw9f1r00pjbvj749q1fg5q22sgrnx7rqjrnwmbl5mh36";
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

  pinba = if isPhp73 then pinba73 else pinba7;

  pinba7 = assert !isPhp73; buildPecl {
    version = "1.1.1";
    pname = "pinba";

    src = pkgs.fetchFromGitHub {
      owner = "tony2001";
      repo = "pinba_extension";
      rev = "RELEASE_1_1_1";
      sha256 = "1kdp7vav0y315695vhm3xifgsh6h6y6pny70xw3iai461n58khj5";
    };

    meta = with pkgs.lib; {
      description = "PHP extension for Pinba";
      longDescription = ''
        Pinba is a MySQL storage engine that acts as a realtime monitoring and
        statistics server for PHP using MySQL as a read-only interface.
      '';
      homepage = "http://pinba.org/";
    };
  };

  pinba73 = assert isPhp73; buildPecl {
    version = "1.1.2-dev";
    pname = "pinba";

    src = pkgs.fetchFromGitHub {
      owner = "tony2001";
      repo = "pinba_extension";
      rev = "edbc313f1b4fb8407bf7d5acf63fbb0359c7fb2e";
      sha256 = "02sljqm6griw8ccqavl23f7w1hp2zflcv24lpf00k6pyrn9cwx80";
    };

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

    buildInputs = with pkgs; [ (if isPhp73 then pcre2 else pcre) ];

    meta = with pkgs.lib; {
      description = ''
        Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data.
      '';
      license = licenses.bsd3;
      homepage = "https://developers.google.com/protocol-buffers/";
    };
  };

  psalm = mkDerivation rec {
    version = "3.7.2";
    pname = "psalm";

    src = pkgs.fetchurl {
      url = "https://github.com/vimeo/psalm/releases/download/${version}/psalm.phar";
      sha256 = "0mcxlckycvpxxc6h0x0kdidbq2l4m3xws1v3kdf797js234x0vjx";
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
      homepage = https://github.com/vimeo/psalm;
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
      homepage = https://psysh.org/;
      maintainers = with maintainers; [ caugner ];
    };
  };

  pthreads = if isPhp73 then pthreads32-dev else pthreads32;

  pthreads32 = assert (pkgs.config.php.zts or false); assert !isPhp73; buildPecl rec {
    version = "3.2.0";
    pname = "pthreads";

    src = pkgs.fetchFromGitHub {
      owner = "krakjoe";
      repo = "pthreads";
      rev = "v${version}";
      sha256 = "17hypm75d4w7lvz96jb7s0s87018yzmmap0l125d5fd7abnhzfvv";
    };

    buildInputs = with pkgs; [ pcre.dev ];
  };

  pthreads32-dev = assert (pkgs.config.php.zts or false); assert isPhp73; buildPecl {
    version = "3.2.0-dev";
    pname = "pthreads";

    src = pkgs.fetchFromGitHub {
      owner = "krakjoe";
      repo = "pthreads";
      rev = "4d1c2483ceb459ea4284db4eb06646d5715e7154";
      sha256 = "07kdxypy0bgggrfav2h1ccbv67lllbvpa3s3zsaqci0gq4fyi830";
    };

    buildInputs = with pkgs; [ pcre2.dev ];
  };

  redis = buildPecl {
    version = "5.1.1";
    pname = "redis";

    sha256 = "1041zv91fkda73w4c3pj6zdvwjgb3q7mxg6mwnq9gisl80mrs732";
  };

  sqlsrv = buildPecl {
    version = "5.6.1";
    pname = "sqlsrv";

    sha256 = "0ial621zxn9zvjh7k1h755sm2lc9aafc389yxksqcxcmm7kqmd0a";

    buildInputs = [ pkgs.unixODBC ];

    meta.broken = isPhp74; # Build error
  };

  v8 = buildPecl {
    version = "0.2.2";
    pname = "v8";

    sha256 = "103nys7zkpi1hifqp9miyl0m1mn07xqshw3sapyz365nb35g5q71";

    buildInputs = [ pkgs.v8_6_x ];
    configureFlags = [ "--with-v8=${pkgs.v8_6_x}" ];
    meta.broken = true;
  };

  v8js = assert !isPhp73; buildPecl {
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

  zmq = assert !isPhp73; buildPecl {
    version = "1.1.3";
    pname = "zmq";

    sha256 = "1kj487vllqj9720vlhfsmv32hs2dy2agp6176mav6ldx31c3g4n4";

    configureFlags = [
      "--with-zmq=${pkgs.zeromq}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
  };
}; in self
