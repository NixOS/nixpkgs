{ pkgs, fetchgit, php }:

let
  self = with self; {
    buildPecl = import ../build-support/build-pecl.nix {
      inherit php;
      inherit (pkgs) stdenv autoreconfHook fetchurl;
    };
  isPhpOlder55 = pkgs.lib.versionOlder php.version "5.5";
  isPhp7 = pkgs.lib.versionAtLeast php.version "7.0";

  apcu = if isPhp7 then apcu51 else apcu40;

  apcu40 = assert !isPhp7; buildPecl {
    name = "apcu-4.0.7";
    sha256 = "1mhbz56mbnq7dryf2d64l84lj3fpr5ilmg2424glans3wcg772hp";
    buildInputs = [ pkgs.pcre ];
  };

  apcu51 = assert isPhp7; buildPecl {
    name = "apcu-5.1.8";
    sha256 = "01dfbf0245d8cc0f51ba16467a60b5fad08e30b28df7846e0dd213da1143ecce";
    buildInputs = [ pkgs.pcre ];
    doCheck = true;
    checkTarget = "test";
    checkFlagsArray = ["REPORT_EXIT_STATUS=1" "NO_INTERACTION=1"];
  };

  ast = assert isPhp7; buildPecl {
    name = "ast-0.1.5";

    sha256 = "0vv2w5fkkw9n7qdmi5aq50416zxmvyzjym8kb6j1v8kd4xcsjjgw";
  };

  couchbase = buildPecl rec {
    name = "couchbase-${version}";
    version = "2.3.4";

    buildInputs = [ pkgs.libcouchbase pkgs.zlib igbinary pcs ];

    src = pkgs.fetchFromGitHub {
      owner = "couchbase";
      repo = "php-couchbase";
      rev = "v${version}";
      sha256 = "0rdlrl7vh4kbxxj9yxp54xpnnrxydpa9fab7dy4nas474j5vb2bp";
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

  php_excel = assert isPhp7; buildPecl rec {
    name = "php_excel";
    version = "1.0.2";
    phpVersion = "php7";

    buildInputs = [ pkgs.libxl ];

    src = pkgs.fetchurl {
      url = "https://github.com/iliaal/${name}/releases/download/Excel-1.0.2-PHP7/excel-${version}-${phpVersion}.tgz";
      sha256 = "0dpvih9gpiyh1ml22zi7hi6kslkilzby00z1p8x248idylldzs2n";
    };

    configureFlags = [ "--with-excel" "--with-libxl-incdir=${pkgs.libxl}/include_c" "--with-libxl-libdir=${pkgs.libxl}/lib" ];
  };

  igbinary = buildPecl {
    name = "igbinary-2.0.4";

    configureFlags = [ "--enable-igbinary" ];

    makeFlags = [ "phpincludedir=$(dev)/include" ];

    outputs = [ "out" "dev" ];

    sha256 = "0a55l4f0bgbf3f6sh34njd14niwagg829gfkvb8n5fs69xqab67d";
  };

  mailparse = assert isPhp7; buildPecl {
    name = "mailparse-3.0.2";

    sha256 = "0fw447ralqihsjnn0fm2hkaj8343cvb90v0d1wfclgz49256y6nq";
  };

  imagick = buildPecl {
    name = "imagick-3.4.3RC1";
    sha256 = "0siyxpszjz6s095s2g2854bhprjq49rf22v6syjiwvndg1pc9fsh";
    configureFlags = "--with-imagick=${pkgs.imagemagick.dev}";
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ pkgs.pcre ];
  };

  # No support for PHP 7 yet
  memcache = assert !isPhp7; buildPecl {
    name = "memcache-3.0.8";

    sha256 = "04c35rj0cvq5ygn2jgmyvqcb0k8d03v4k642b6i37zgv7x15pbic";

    configureFlags = "--with-zlib-dir=${pkgs.zlib.dev}";

    makeFlags = [ "CFLAGS=-fgnu89-inline" ];
  };

  memcached = if isPhp7 then memcachedPhp7 else memcached22;

  memcached22 = assert !isPhp7; buildPecl {
    name = "memcached-2.2.0";

    sha256 = "0n4z2mp4rvrbmxq079zdsrhjxjkmhz6mzi7mlcipz02cdl7n1f8p";

    configureFlags = [
      "--with-zlib-dir=${pkgs.zlib.dev}"
      "--with-libmemcached-dir=${pkgs.libmemcached}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with pkgs; [ cyrus_sasl zlib ];
  };

  # Not released yet
  memcachedPhp7 = assert isPhp7; buildPecl rec {
    name = "memcached-php7";

    src = fetchgit {
      url = "https://github.com/php-memcached-dev/php-memcached";
      rev = "e573a6e8fc815f12153d2afd561fc84f74811e2f";
      sha256 = "0asfi6rsspbwbxhwmkxxnapd8w01xvfmwr1n9qsr2pryfk0w6y07";
    };

    configureFlags = [
      "--with-zlib-dir=${pkgs.zlib.dev}"
      "--with-libmemcached-dir=${pkgs.libmemcached}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with pkgs; [ cyrus_sasl zlib ];
  };

  pcs = buildPecl rec {
    name = "pcs-1.3.3";

    sha256 = "0d4p1gpl8gkzdiv860qzxfz250ryf0wmjgyc8qcaaqgkdyh5jy5p";
  };

  # No support for PHP 7 yet (and probably never will be)
  spidermonkey = assert !isPhp7; buildPecl rec {
    name = "spidermonkey-1.0.0";

    sha256 = "1ywrsp90w6rlgq3v2vmvp2zvvykkgqqasab7h9bf3vgvgv3qasbg";

    configureFlags = [
      "--with-spidermonkey=${pkgs.spidermonkey_1_8_5}"
    ];

    buildInputs = [ pkgs.spidermonkey_1_8_5 ];
  };

  xdebug = if isPhp7 then xdebug26 else xdebug23;

  xdebug23 = assert !isPhp7; buildPecl {
    name = "xdebug-2.3.1";

    sha256 = "0k567i6w7cw14m13s7ip0946pvy5ii16cjwjcinnviw9c24na0xm";

    doCheck = true;
    checkTarget = "test";
  };

  xdebug26 = assert isPhp7; buildPecl {
    name = "xdebug-2.6.0";

    sha256 = "1p6b54ypi5lq4ka3pyy2gswdf1d5vjb9y8lp9fqcp3zn7g04q9mm";

    doCheck = true;
    checkTarget = "test";
  };

  yaml = if isPhp7 then yaml20 else yaml13;

  yaml13 = assert !isPhp7; buildPecl {
    name = "yaml-1.3.1";

    sha256 = "1fbmgsgnd6l0d4vbjaca0x9mrfgl99yix5yf0q0pfcqzfdg4bj8q";

    configureFlags = [
      "--with-yaml=${pkgs.libyaml}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
  };

  yaml20 = assert isPhp7; buildPecl {
    name = "yaml-2.0.2";

    sha256 = "0f80zy79kyy4hn6iigpgfkwppwldjfj5g7s4gddklv3vskdb1by3";

    configureFlags = [
      "--with-yaml=${pkgs.libyaml}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
  };

  # Since PHP 5.5 OPcache is integrated in the core and has to be enabled via --enable-opcache during compilation.
  zendopcache = assert isPhpOlder55; buildPecl {
    name = "zendopcache-7.0.3";

    sha256 = "0qpfbkfy4wlnsfq4vc4q5wvaia83l89ky33s08gqrcfp3p1adn88";
  };

  zmq = buildPecl {
    name = "zmq-1.1.3";

    sha256 = "1kj487vllqj9720vlhfsmv32hs2dy2agp6176mav6ldx31c3g4n4";

    configureFlags = [
      "--with-zmq=${pkgs.zeromq}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
  };

  # No support for PHP 7 and probably never will be
  xcache = assert !isPhp7; buildPecl rec {
    name = "xcache-${version}";

    version = "3.2.0";

    src = pkgs.fetchurl {
      url = "http://xcache.lighttpd.net/pub/Releases/${version}/${name}.tar.bz2";
      sha256 = "1gbcpw64da9ynjxv70jybwf9y88idm01kb16j87vfagpsp5s64kx";
    };

    doCheck = true;
    checkTarget = "test";

    configureFlags = [
      "--enable-xcache"
      "--enable-xcache-coverager"
      "--enable-xcache-optimizer"
      "--enable-xcache-assembler"
      "--enable-xcache-encoder"
      "--enable-xcache-decoder"
    ];

    buildInputs = [ pkgs.m4 ];
  };

  #pthreads requires a build of PHP with ZTS (Zend Thread Safety) enabled
  #--enable-maintainer-zts or --enable-zts on Windows
  pthreads = if isPhp7 then pthreads31 else pthreads20;

  pthreads20 = assert (pkgs.config.php.zts or false) && (!isPhp7); buildPecl {
    name = "pthreads-2.0.10";
    sha256 = "1xlcb1b1g10jd0xhm3c01a06yqpb5qln47pd1k522138324qvpwb";
  };

  pthreads31 = assert (pkgs.config.php.zts or false) && isPhp7; buildPecl {
    name = "pthreads-3.1.5";
    sha256 = "1ziap0py3zrc7qj9lw4nzq6wx1viyj8v9y1babchizzan014x6p5";
  };

  # No support for PHP 7 yet
  geoip = assert !isPhp7; buildPecl {
    name = "geoip-1.1.0";
    sha256 = "1fcqpsvwba84gqqmwyb5x5xhkazprwkpsnn4sv2gfbsd4svxxil2";

    configureFlags = [ "--with-geoip=${pkgs.geoip}" ];

    buildInputs = [ pkgs.geoip ];
  };

  redis = if isPhp7 then redis31 else redis22;

  redis22 = assert !isPhp7; buildPecl {
    name = "redis-2.2.7";
    sha256 = "00n9dpk9ak0bl35sbcd3msr78sijrxdlb727nhg7f2g7swf37rcm";
  };

  redis31 = assert isPhp7; buildPecl {
    name = "redis-3.1.4";
    sha256 = "0rgjdrqfif8pfn3ipk1v4gyjkkdcdrdk479qbpda89w25vaxzsxd";
  };

  v8 = assert isPhp7; buildPecl rec {
    version = "0.1.9";
    name = "v8-${version}";

    sha256 = "0bj77dfmld5wfwl4wgqnpa0i4f3mc1mpsp9dmrwqv050gs84m7h1";

    buildInputs = [ pkgs.v8_6_x ];
    configureFlags = [ "--with-v8=${pkgs.v8_6_x}" ];
  };

  v8js = assert isPhp7; buildPecl rec {
    version = "1.4.1";
    name = "v8js-${version}";

    sha256 = "0k5dc395gzva4l6n9mzvkhkjq914460cwk1grfandcqy73j6m89q";

    buildInputs = [ pkgs.v8_6_x ];
    configureFlags = [ "--with-v8js=${pkgs.v8_6_x}" ];
  };

  composer = pkgs.stdenv.mkDerivation rec {
    name = "composer-${version}";
    version = "1.6.3";

    src = pkgs.fetchurl {
      url = "https://getcomposer.org/download/${version}/composer.phar";
      sha256 = "1dna9ng77nw002l7hq60b6vz0f1snmnsxj1l7cg4f877msxppjsj";
    };

    unpackPhase = ":";

    buildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin
      install -D $src $out/libexec/composer/composer.phar
      makeWrapper ${php}/bin/php $out/bin/composer \
        --add-flags "$out/libexec/composer/composer.phar"
    '';

    meta = with pkgs.lib; {
      description = "Dependency Manager for PHP";
      license = licenses.mit;
      homepage = https://getcomposer.org/;
      maintainers = with maintainers; [ globin offline ];
    };
  };

  box = pkgs.stdenv.mkDerivation rec {
    name = "box-${version}";
    version = "2.7.5";

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

  php-cs-fixer = pkgs.stdenv.mkDerivation rec {
    name = "php-cs-fixer-${version}";
    version = "2.10.3";

    src = pkgs.fetchurl {
      url = "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${version}/php-cs-fixer.phar";
      sha256 = "0ir72sns8baz825dkvffr5rx1f261phhbc6d9v0ncc4xkhr5zjnh";
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
    name = "php-parallel-lint-${version}";
    version = "1.0.0";

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

  phpcs = pkgs.stdenv.mkDerivation rec {
    name = "phpcs-${version}";
    version = "3.2.3";

    src = pkgs.fetchurl {
      url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
      sha256 = "193axz56j1kyq458q0y38m99bx31jjjldfg6bv71vgm6zh4rvvs1";
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

  phpcbf = pkgs.stdenv.mkDerivation rec {
    name = "phpcbf-${version}";
    version = "3.2.3";

    src = pkgs.fetchurl {
      url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcbf.phar";
      sha256 = "00p0l01shxx1h6g26j2dbfrp9j7im541das4xps4wrsvc4h4da9l";
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
}; in self
