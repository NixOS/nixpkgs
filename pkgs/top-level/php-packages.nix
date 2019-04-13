{ pkgs, fetchgit, php }:

let
  self = with self; {
    buildPecl = import ../build-support/build-pecl.nix {
      inherit php;
      inherit (pkgs) stdenv autoreconfHook fetchurl;
    };

  isPhp73 = pkgs.lib.versionAtLeast php.version "7.3";

  apcu = buildPecl {
    name = "apcu-5.1.17";
    sha256 = "14y7alvj5q17q1b544bxidavkn6i40cjbq2nv1m0k70ai5vv84bb";
    buildInputs = [ (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
    doCheck = true;
    checkTarget = "test";
    checkFlagsArray = ["REPORT_EXIT_STATUS=1" "NO_INTERACTION=1"];
    makeFlags = [ "phpincludedir=$(dev)/include" ];
    outputs = [ "out" "dev" ];
  };

  apcu_bc = buildPecl {
    name = "apcu_bc-1.0.5";
    sha256 = "0ma00syhk2ps9k9p02jz7rii6x3i2p986il23703zz5npd6y9n20";
    buildInputs = [ apcu (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
  };

  ast = buildPecl {
    name = "ast-1.0.0";

    sha256 = "0abccvwif1pih222lbj2z4cf9ibciz48xj35lfixyry163vabkck";
  };

  couchbase = buildPecl rec {
    name = "couchbase-${version}";
    version = "2.6.0";

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

  php_excel = buildPecl rec {
    name = "php_excel-${version}";
    version = "1.0.2";
    phpVersion = "php7";

    buildInputs = [ pkgs.libxl ];

    src = pkgs.fetchurl {
      url = "https://github.com/iliaal/php_excel/releases/download/Excel-1.0.2-PHP7/excel-${version}-${phpVersion}.tgz";
      sha256 = "0dpvih9gpiyh1ml22zi7hi6kslkilzby00z1p8x248idylldzs2n";
    };

    configureFlags = [ "--with-excel" "--with-libxl-incdir=${pkgs.libxl}/include_c" "--with-libxl-libdir=${pkgs.libxl}/lib" ];
  };

  igbinary = buildPecl {
    name = "igbinary-2.0.8";

    configureFlags = [ "--enable-igbinary" ];

    makeFlags = [ "phpincludedir=$(dev)/include" ];

    outputs = [ "out" "dev" ];

    sha256 = "105nyn703k9p9c7wwy6npq7xd9mczmmlhyn0gn2v2wz0f88spjxs";
  };

  mailparse = assert !isPhp73; buildPecl {
    name = "mailparse-3.0.2";

    sha256 = "0fw447ralqihsjnn0fm2hkaj8343cvb90v0d1wfclgz49256y6nq";
  };

  imagick = buildPecl {
    name = "imagick-3.4.3";
    sha256 = "0z2nc92xfc5axa9f2dy95rmsd2c81q8cs1pm4anh0a50x9g5ng0z";
    configureFlags = [ "--with-imagick=${pkgs.imagemagick.dev}" ];
    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = [ (if isPhp73 then pkgs.pcre2 else pkgs.pcre) ];
  };

  memcached = if isPhp73 then memcached73 else memcached7;

  memcached7 = assert !isPhp73; buildPecl rec {
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

  memcached73 = assert isPhp73; buildPecl rec {
    name = "memcached-php73";

    src = fetchgit {
      url = "https://github.com/php-memcached-dev/php-memcached";
      rev = "6d8f5d524f35e72422b9e81319b96f23af02adcc";
      sha256 = "1s1d5r3n2h9zys8sqvv52fld6jy21ki7cl0gbbvd9dixqc0lf1jh";
    };

    configureFlags = [
      "--with-zlib-dir=${pkgs.zlib.dev}"
      "--with-libmemcached-dir=${pkgs.libmemcached}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
    buildInputs = with pkgs; [ cyrus_sasl zlib ];
  };

  oci8 = buildPecl rec {
    name = "oci8-2.1.8";
    sha256 = "1bp6fss2f2qmd5bdk7x22j8vx5qivrdhz4x7csf29vjgj6gvchxy";
    buildInputs = [ pkgs.re2c pkgs.oracle-instantclient ];
    configureFlags = [ "--with-oci8=shared,instantclient,${pkgs.oracle-instantclient}/lib" ];
  };

  pcs = buildPecl rec {
    name = "pcs-1.3.3";

    sha256 = "0d4p1gpl8gkzdiv860qzxfz250ryf0wmjgyc8qcaaqgkdyh5jy5p";
  };

  sqlsrv = buildPecl rec {
    name = "sqlsrv-5.6.1";
    sha256 = "0ial621zxn9zvjh7k1h755sm2lc9aafc389yxksqcxcmm7kqmd0a";
    buildInputs = [ pkgs.unixODBC ];
  };

  pdo_sqlsrv = buildPecl rec {
    name = "pdo_sqlsrv-5.6.1";
    sha256 = "02ill1iqffa5fha9iz4y91823scml24ikfk8pn90jyycfwv07x6a";
    buildInputs = [ pkgs.unixODBC ];
  };

  xdebug =  if isPhp73 then xdebug73 else xdebug7;

  xdebug7 = assert !isPhp73; buildPecl {
    name = "xdebug-2.6.1";

    sha256 = "0xxxy6n4lv7ghi9liqx133yskg07lw316vhcds43n1sjq3b93rns";

    doCheck = true;
    checkTarget = "test";
  };

  xdebug73 = assert isPhp73; buildPecl {
    name = "xdebug-2.7.0beta1";

    sha256 = "1ghh14z55l4jklinkgjkfhkw53lp2r7lgmyh7q8kdnf7jnpwx84h";

    doCheck = true;
    checkTarget = "test";
  };

  yaml = buildPecl {
    name = "yaml-2.0.4";

    sha256 = "1036zhc5yskdfymyk8jhwc34kvkvsn5kaf50336153v4dqwb11lp";

    configureFlags = [
      "--with-yaml=${pkgs.libyaml}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
  };

  zmq = assert !isPhp73; buildPecl {
    name = "zmq-1.1.3";

    sha256 = "1kj487vllqj9720vlhfsmv32hs2dy2agp6176mav6ldx31c3g4n4";

    configureFlags = [
      "--with-zmq=${pkgs.zeromq}"
    ];

    nativeBuildInputs = [ pkgs.pkgconfig ];
  };

  pthreads = assert (pkgs.config.php.zts or false); buildPecl {
    name = "pthreads-3.1.5";
    sha256 = "1ziap0py3zrc7qj9lw4nzq6wx1viyj8v9y1babchizzan014x6p5";
    meta.broken = true;
  };

  redis = buildPecl {
    name = "redis-4.2.0";
    sha256 = "105k2rfz97svrqzdhd0a0668mn71c8v0j7hks95832fsvn5dhmbn";
  };

  v8 = buildPecl rec {
    version = "0.2.2";
    name = "v8-${version}";

    sha256 = "103nys7zkpi1hifqp9miyl0m1mn07xqshw3sapyz365nb35g5q71";

    buildInputs = [ pkgs.v8_6_x ];
    configureFlags = [ "--with-v8=${pkgs.v8_6_x}" ];
  };

  v8js = assert !isPhp73; buildPecl rec {
    version = "2.1.0";
    name = "v8js-${version}";

    sha256 = "0g63dyhhicngbgqg34wl91nm3556vzdgkq19gy52gvmqj47rj6rg";

    buildInputs = [ pkgs.v8_6_x ];
    configureFlags = [ "--with-v8js=${pkgs.v8_6_x}" ];
  };

  composer = pkgs.stdenv.mkDerivation rec {
    pname = "composer";
    version = "1.8.4";

    src = pkgs.fetchurl {
      url = "https://getcomposer.org/download/${version}/composer.phar";
      sha256 = "12h5vqwhklxvwrplggzjl21n6kb972pwkj9ivmn2vbxyixn848hp";
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
    version = "2.14.0";

    src = pkgs.fetchurl {
      url = "https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v${version}/php-cs-fixer.phar";
      sha256 = "0ap5bhm1h2ldyzlch7bz5n3jj2bpm4wd6bzw51g414pk9vksswc1";
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
    pname = "phpcs";
    version = "3.4.1";

    src = pkgs.fetchurl {
      url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
      sha256 = "07zwj8msy0awnrwmv3gcilbsj9jyrvxw0q523yf16ydv55422pl0";
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
    pname = "phpcbf";
    version = "3.4.1";

    src = pkgs.fetchurl {
      url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcbf.phar";
      sha256 = "052fsgzc39mfjy34mv1ip2qdghypsy218wfp8vh3a593pzkmzdcv";
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

  phpstan = pkgs.stdenv.mkDerivation rec {
    pname = "phpstan";
    version = "0.11.5";

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
    name = "psysh-${version}";
    version = "0.9.8";

    src = pkgs.fetchurl {
      url = "https://github.com/bobthecow/psysh/releases/download/v${version}/psysh-v${version}.tar.gz";
      sha256 = "0xs9bl0hplkm2hajmm4qca65bm2x7wnx4vbmk0d2jxpvwrgqgnzd";
    };

    phases = [ "installPhase" ];
    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
      mkdir -p $out/bin
      tar -xzf $src -C $out/bin
      wrapProgram $out/bin/psysh
    '';

    meta = with pkgs.lib; {
      description = "PsySH is a runtime developer console, interactive debugger and REPL for PHP.";
      license = licenses.mit;
      homepage = https://psysh.org/;
      maintainers = with maintainers; [ caugner ];
    };
  };
}; in self
