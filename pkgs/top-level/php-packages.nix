{ pkgs, fetchgit, php }:

let
  self = with self; {
    buildPecl = import ../build-support/build-pecl.nix {
      inherit php;
      inherit (pkgs) stdenv autoreconfHook fetchurl;
    };

  isPhp73 = pkgs.lib.versionAtLeast php.version "7.3";

  apcu = buildPecl rec {
    version = "5.1.17";
    pname = "apcu";

    sha256 = "14y7alvj5q17q1b544bxidavkn6i40cjbq2nv1m0k70ai5vv84bb";

    buildInputs = [ (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
    doCheck = true;
    checkTarget = "test";
    checkFlagsArray = ["REPORT_EXIT_STATUS=1" "NO_INTERACTION=1"];
    makeFlags = [ "phpincludedir=$(dev)/include" ];
    outputs = [ "out" "dev" ];
  };

  apcu_bc = buildPecl rec {
    version = "1.0.5";
    pname = "apcu_bc";

    sha256 = "0ma00syhk2ps9k9p02jz7rii6x3i2p986il23703zz5npd6y9n20";

    buildInputs = [ apcu (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
  };

  ast = buildPecl rec {
    version = "1.0.1";
    pname = "ast";

    sha256 = "0ja74k2lmxwhhvp9y9kc7khijd7s2dqma5x8ghbhx9ajkn0wg8iq";
  };

  box = pkgs.stdenv.mkDerivation rec {
    version = "2.7.5";
    pname = "php-box";

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

  composer = pkgs.stdenv.mkDerivation rec {
    version = "1.8.5";
    pname = "php-composer";

    src = pkgs.fetchurl {
      url = "https://getcomposer.org/download/${version}/composer.phar";
      sha256 = "05qfgh2dz8pjf47ndyhkicqbnqzwypk90cczd4c6d8jl9gbiqk2f";
    };

    unpackPhase = ":";

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
    version = "2.6.0";
    pname = "couchbase";

    buildInputs = [ pkgs.libcouchbase pkgs.zlib igbinary pcs ];

    src = pkgs.fetchFromGitHub {
      owner = "couchbase";
      repo = "php-couchbase";
      rev = "v${version}";
      sha256 = "0lhcvgd4a0wvxniinxajj48p5krbp44h8932021qq14rv94r4k0b";
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
  };

  igbinary = buildPecl rec {
    version = "3.0.1";
    pname = "igbinary";

    sha256 = "1w8jmf1qpggdvq0ndfi86n7i7cqgh1s8q6hys2lijvi37rzn0nar";

    configureFlags = [ "--enable-igbinary" ];
    makeFlags = [ "phpincludedir=$(dev)/include" ];
    outputs = [ "out" "dev" ];
  };

  imagick = buildPecl rec {
    version = "3.4.3";
    pname = "imagick";

    sha256 = "0z2nc92xfc5axa9f2dy95rmsd2c81q8cs1pm4anh0a50x9g5ng0z";

    configureFlags = [ "--with-imagick=${pkgs.imagemagick.dev}" ];
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
  };

  mailparse = assert !isPhp73; buildPecl rec {
    version = "3.0.2";
    pname = "mailparse";

    sha256 = "0fw447ralqihsjnn0fm2hkaj8343cvb90v0d1wfclgz49256y6nq";
  };

  memcached = buildPecl rec {
    version = "3.1.3";
    pname = "memcached";

    src = fetchgit {
      url = "https://github.com/php-memcached-dev/php-memcached";
      rev = "v${version}";
      sha256 = "1w9g8k7bmq3nbzskskpsr5632gh9q75nqy7nkjdzgs17klq9khjk";
    };

    configureFlags = [
      "--with-zlib-dir=${pkgs.zlib.dev}"
      "--with-libmemcached-dir=${pkgs.libmemcached}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with pkgs; [ cyrus_sasl zlib ];
  };

  oci8 = buildPecl rec {
    version = "2.2.0";
    pname = "oci8";

    sha256 = "0jhivxj1nkkza4h23z33y7xhffii60d7dr51h1czjk10qywl7pyd";

    buildInputs = [ pkgs.re2c pkgs.oracle-instantclient ];
    configureFlags = [ "--with-oci8=shared,instantclient,${pkgs.oracle-instantclient}/lib" ];
  };

  pcs = buildPecl rec {
    version = "1.3.3";
    pname = "pcs";

    sha256 = "0d4p1gpl8gkzdiv860qzxfz250ryf0wmjgyc8qcaaqgkdyh5jy5p";
  };

  pdo_sqlsrv = buildPecl rec {
    version = "5.6.1";
    pname = "pdo_sqlsrv";

    sha256 = "02ill1iqffa5fha9iz4y91823scml24ikfk8pn90jyycfwv07x6a";

    buildInputs = [ pkgs.unixODBC ];
  };

  php-cs-fixer = pkgs.stdenv.mkDerivation rec {
    version = "2.14.2";
    pname = "php-cs-fixer";

    src = pkgs.fetchurl {
      url = "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${version}/php-cs-fixer.phar";
      sha256 = "1d5msgrkiim8iwkkrq3m1cnx7wfi96m1qs6rbh279kw5ysvzkaj9";
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

  php-parallel-lint = pkgs.stdenv.mkDerivation rec {
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

  phpcbf = pkgs.stdenv.mkDerivation rec {
    version = "3.4.2";
    pname = "php-phpcbf";

    src = pkgs.fetchurl {
      url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcbf.phar";
      sha256 = "08s47r8i5dyjivk1q3nhrz40n6fx3zghrn5irsxfnx5nj9pb7ffp";
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

  phpcs = pkgs.stdenv.mkDerivation rec {
    version = "3.4.2";
    pname = "php-phpcs";

    src = pkgs.fetchurl {
      url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
      sha256 = "0hk9w5kn72z9xhswfmxilb2wk96vy07z4a1pwrpspjlr23aajrk9";
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

  phpstan = pkgs.stdenv.mkDerivation rec {
    version = "0.11.5";
    pname = "phpstan";

    src = pkgs.fetchurl {
      url = "https://github.com/phpstan/phpstan/releases/download/${version}/phpstan.phar";
      sha256 = "13akllfr5dav0y61i4ym5ww8z32ynwj5lpvsfiwx6z52avmcrc29";
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
      homepage = https://github.com/phpstan/phpstan;
      maintainers = with maintainers; [ etu ];
    };
  };

  psysh = pkgs.stdenv.mkDerivation rec {
    version = "0.9.9";
    pname = "psysh";

    src = pkgs.fetchurl {
      url = "https://github.com/bobthecow/psysh/releases/download/v${version}/psysh-v${version}.tar.gz";
      sha256 = "0knbib0afwq2z5fc639ns43x8pi3kmp85y13bkcl00dhvf46yinw";
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

  pthreads = assert (pkgs.config.php.zts or false); buildPecl rec {
    version = "3.1.5";
    pname = "pthreads";

    sha256 = "1ziap0py3zrc7qj9lw4nzq6wx1viyj8v9y1babchizzan014x6p5";

    meta.broken = true;
  };

  redis = buildPecl rec {
    version = "4.3.0";
    pname = "redis";

    sha256 = "18hvll173mlp6dk6xvgajkjf4min8f5gn809nr1ahq4r6kn4rw60";
  };

  sqlsrv = buildPecl rec {
    version = "5.6.1";
    pname = "sqlsrv";

    sha256 = "0ial621zxn9zvjh7k1h755sm2lc9aafc389yxksqcxcmm7kqmd0a";

    buildInputs = [ pkgs.unixODBC ];
  };

  v8 = buildPecl rec {
    version = "0.2.2";
    pname = "v8";

    sha256 = "103nys7zkpi1hifqp9miyl0m1mn07xqshw3sapyz365nb35g5q71";

    buildInputs = [ pkgs.v8_6_x ];
    configureFlags = [ "--with-v8=${pkgs.v8_6_x}" ];
    meta.broken = true;
  };

  v8js = assert !isPhp73; buildPecl rec {
    version = "2.1.0";
    pname = "v8js";

    sha256 = "0g63dyhhicngbgqg34wl91nm3556vzdgkq19gy52gvmqj47rj6rg";

    buildInputs = [ pkgs.v8_6_x ];
    configureFlags = [ "--with-v8js=${pkgs.v8_6_x}" ];
    meta.broken = true;
  };

  xdebug = buildPecl rec {
    version = "2.7.1";
    pname = "xdebug";

    sha256 = "1hr4gy87a3gp682ggwp831xk1fxasil9wan8cxv23q3m752x3sdp";

    doCheck = true;
    checkTarget = "test";
  };

  yaml = buildPecl rec {
    version = "2.0.4";
    pname = "yaml";

    sha256 = "1036zhc5yskdfymyk8jhwc34kvkvsn5kaf50336153v4dqwb11lp";

    configureFlags = [
      "--with-yaml=${pkgs.libyaml}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
  };

  zmq = assert !isPhp73; buildPecl rec {
    version = "1.1.3";
    pname = "zmq";

    sha256 = "1kj487vllqj9720vlhfsmv32hs2dy2agp6176mav6ldx31c3g4n4";

    configureFlags = [
      "--with-zmq=${pkgs.zeromq}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
  };
}; in self
