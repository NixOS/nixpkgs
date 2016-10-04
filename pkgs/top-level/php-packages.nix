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
  };

  apcu51 = assert isPhp7; buildPecl {
    name = "apcu-5.1.2";

    sha256 = "0r5pfbjbmdj46h20jm3iqmy969qd27ajyf0phjhgykv6j0cqjlgd";
  };

  imagick = if isPhp7 then imagick34 else imagick31;

  imagick31 = assert !isPhp7; buildPecl {
    name = "imagick-3.1.2";
    sha256 = "14vclf2pqcgf3w8nzqbdw0b9v30q898344c84jdbw2sa62n6k1sj";
    configureFlags = "--with-imagick=${pkgs.imagemagick.dev}";
    buildInputs = [ pkgs.pkgconfig ];
  };

  imagick34 = buildPecl {
    name = "imagick-3.4.0RC4";
    sha256 = "0fdkzdv3r8sm6y1x11kp3rxsimq6zf15xvi0mhn57svmnan4zh0i";
    configureFlags = "--with-imagick=${pkgs.imagemagick.dev}";
    buildInputs = [ pkgs.pkgconfig ];
  };

  # No support for PHP 7 yet
  memcache = assert !isPhp7; buildPecl {
    name = "memcache-3.0.8";

    sha256 = "04c35rj0cvq5ygn2jgmyvqcb0k8d03v4k642b6i37zgv7x15pbic";

    configureFlags = "--with-zlib-dir=${pkgs.zlib.dev}";
  };

  memcached = if isPhp7 then memcachedPhp7 else memcached22;

  memcached22 = assert !isPhp7; buildPecl {
    name = "memcached-2.2.0";

    sha256 = "0n4z2mp4rvrbmxq079zdsrhjxjkmhz6mzi7mlcipz02cdl7n1f8p";

    configureFlags = [
      "--with-zlib-dir=${pkgs.zlib.dev}"
      "--with-libmemcached-dir=${pkgs.libmemcached}"
    ];

    buildInputs = with pkgs; [ pkgconfig cyrus_sasl ];
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

    buildInputs = with pkgs; [ pkgconfig cyrus_sasl ];
  };

  # No support for PHP 7 yet (and probably never will be)
  spidermonkey = assert !isPhp7; buildPecl rec {
    name = "spidermonkey-1.0.0";

    sha256 = "1ywrsp90w6rlgq3v2vmvp2zvvykkgqqasab7h9bf3vgvgv3qasbg";

    configureFlags = [
      "--with-spidermonkey=${pkgs.spidermonkey_185}"
    ];

    buildInputs = [ pkgs.spidermonkey_185 ];
  };

  xdebug = if isPhp7 then xdebug24 else xdebug23;

  xdebug23 = assert !isPhp7; buildPecl {
    name = "xdebug-2.3.1";

    sha256 = "0k567i6w7cw14m13s7ip0946pvy5ii16cjwjcinnviw9c24na0xm";

    doCheck = true;
    checkTarget = "test";
  };

  xdebug24 = buildPecl {
    name = "xdebug-2.4.0RC3";

    sha256 = "06ppsihw4cl8kxmywvic6wsm4ps9pvsns2vbab9ivrfyp8b6h5dy";

    doCheck = true;
    checkTarget = "test";
  };

  # Since PHP 5.5 OPcache is integrated in the core and has to be enabled via --enable-opcache during compilation.
  zendopcache = assert isPhpOlder55; buildPecl {
    name = "zendopcache-7.0.3";

    sha256 = "0qpfbkfy4wlnsfq4vc4q5wvaia83l89ky33s08gqrcfp3p1adn88";
  };

  zmq = if isPhp7 then zmqPhp7 else zmq11;

  zmq11 = assert !isPhp7; buildPecl {
    name = "zmq-1.1.2";

    sha256 = "0ccz73p8pkda3y9p9qbr3m19m0yrf7k2bvqgbaly3ibgh9bazc69";

    configureFlags = [
      "--with-zmq=${pkgs.zeromq2}"
    ];

    buildInputs = [ pkgs.pkgconfig ];
  };

  # Not released yet
  zmqPhp7 = assert isPhp7; buildPecl rec {
    name = "zmq-php7";

    src = fetchgit {
      url = "https://github.com/mkoppanen/php-zmq";
      rev = "94d2b87d195f870775b153b42c29f30da049f4db";
      sha256 = "51a25b1029800d8abe03c5c08c50d6aee941c95c741dc22d2f853052511f4296";
    };

    configureFlags = [
      "--with-zmq=${pkgs.zeromq2}"
    ];

    buildInputs = [ pkgs.pkgconfig ];
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

  redis = if isPhp7 then redisPhp7 else redis22;

  redis22 = buildPecl {
    name = "redis-2.2.7";
    sha256 = "00n9dpk9ak0bl35sbcd3msr78sijrxdlb727nhg7f2g7swf37rcm";
  };

  # Not released yet
  redisPhp7 = assert isPhp7; buildPecl rec {
    name = "redis-php7";

    src = fetchgit {
      url = "https://github.com/phpredis/phpredis";
      rev = "4a37e47d0256581ce2f7a3b15b5bb932add09f36";
      sha256 = "1qm2ifa0zf95l1g967iiabmja17srpwz73lfci7z13ffdw1ayhfd";
    };
  };

  v8 = assert isPhp7; buildPecl rec {
    version = "0.1.0";
    name = "v8-${version}";

    src = pkgs.fetchurl {
      url = "https://github.com/pinepain/php-v8/archive/v${version}.tar.gz";
      sha256 = "18smnxd34b486f5n8j0wk9z7r5x1w84v89mgf76z0bn7gxdxl0xj";
    };

    buildInputs = [ pkgs.v8 ];
    configureFlags = [ "--with-v8=${pkgs.v8}" ];

    patches = [
      (builtins.toFile "link-libv8_libbase.patch" ''
        Index: php-v8/config.m4
        ===================================================================
        --- php-v8.orig/config.m4
        +++ php-v8/config.m4
        @@ -69,7 +69,7 @@ if test "$PHP_V8" != "no"; then
               #static_link_extra="libv8_base.a libv8_libbase.a libv8_libplatform.a libv8_snapshot.a"
               ;;
             * )
        -      static_link_extra="libv8_libplatform.a"
        +      static_link_extra="libv8_libplatform.a libv8_libbase.a"
               #static_link_extra="libv8_base.a libv8_libbase.a libv8_libplatform.a libv8_snapshot.a"
               ;;
           esac
	''
      )];
  };

  v8js = assert isPhp7; buildPecl rec {
    version = "1.3.2";
    name = "v8js-${version}";

    sha256 = "1x7gxi70zgj3vaxs89nfbnwlqcxrps1inlyfzz66pbzdbfwvc8z8";

    buildInputs = [ pkgs.v8 ];
    configureFlags = [ "--with-v8js=${pkgs.v8}" ];
  };

  composer = pkgs.stdenv.mkDerivation rec {
    name = "composer-${version}";
    version = "1.2.0";

    src = pkgs.fetchurl {
      url = "https://getcomposer.org/download/${version}/composer.phar";
      sha256 = "15chwfsqmwmhry3bv13a5y4ih1vzb0j8h1dfd49pnzzd8lai706w";
    };

    phases = [ "installPhase" ];
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

  phpcs = pkgs.stdenv.mkDerivation rec {
    name = "phpcs-${version}";
    version = "2.6.0";

    src = pkgs.fetchurl {
      url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
      sha256 = "02mlv44x508rnkzkwiyh7lg2ah7aqyxcq65q9ycj06czm0xdzs41";
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
      maintainers = with maintainers; [ javaguirre ];
    };
  };
}; in self
