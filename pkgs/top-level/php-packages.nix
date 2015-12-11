{ pkgs, php }:

let self = with self; {
  buildPecl = import ../build-support/build-pecl.nix {
    inherit php;
    inherit (pkgs) stdenv autoreconfHook fetchurl;
  };

  apcu = buildPecl {
    name = "apcu-4.0.7";

    sha256 = "1mhbz56mbnq7dryf2d64l84lj3fpr5ilmg2424glans3wcg772hp";
  };

  imagick = buildPecl {
    name = "imagick-3.1.2";
    sha256 = "14vclf2pqcgf3w8nzqbdw0b9v30q898344c84jdbw2sa62n6k1sj";
    configureFlags = "--with-imagick=${pkgs.imagemagick}";
    buildInputs = [ pkgs.pkgconfig ];
  };

  memcache = buildPecl {
    name = "memcache-3.0.8";

    sha256 = "04c35rj0cvq5ygn2jgmyvqcb0k8d03v4k642b6i37zgv7x15pbic";

    configureFlags = "--with-zlib-dir=${pkgs.zlib}";
  };

  memcached = buildPecl {
    name = "memcached-2.2.0";

    sha256 = "0n4z2mp4rvrbmxq079zdsrhjxjkmhz6mzi7mlcipz02cdl7n1f8p";

    configureFlags = [
      "--with-zlib-dir=${pkgs.zlib}"
      "--with-libmemcached-dir=${pkgs.libmemcached}"
    ];

    buildInputs = with pkgs; [ pkgconfig cyrus_sasl ];
  };

  xdebug = buildPecl {
    name = "xdebug-2.3.1";

    sha256 = "0k567i6w7cw14m13s7ip0946pvy5ii16cjwjcinnviw9c24na0xm";

    doCheck = true;
    checkTarget = "test";
  };

  zendopcache = buildPecl {
    name = "zendopcache-7.0.3";

    sha256 = "0qpfbkfy4wlnsfq4vc4q5wvaia83l89ky33s08gqrcfp3p1adn88";
  };

  zmq = buildPecl {
    name = "zmq-1.1.2";

    sha256 = "0ccz73p8pkda3y9p9qbr3m19m0yrf7k2bvqgbaly3ibgh9bazc69";

    configureFlags = [
      "--with-zmq=${pkgs.zeromq2}"
    ];

    buildInputs = [ pkgs.pkgconfig ];
  };

  xcache = buildPecl rec {
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

  pthreads = assert pkgs.config.php.zts or false; buildPecl {
    #pthreads requires a build of PHP with ZTS (Zend Thread Safety) enabled
    #--enable-maintainer-zts or --enable-zts on Windows
    name = "pthreads-2.0.10";
    sha256 = "1xlcb1b1g10jd0xhm3c01a06yqpb5qln47pd1k522138324qvpwb";
  };

  geoip = buildPecl {
    name = "geoip-1.1.0";
    sha256 = "1fcqpsvwba84gqqmwyb5x5xhkazprwkpsnn4sv2gfbsd4svxxil2";

    configureFlags = [ "--with-geoip=${pkgs.geoip}" ];

    buildInputs = [ pkgs.geoip ];
  };

  redis = buildPecl {
    name = "redis-2.2.7";
    sha256 = "00n9dpk9ak0bl35sbcd3msr78sijrxdlb727nhg7f2g7swf37rcm";
  };

  composer = pkgs.stdenv.mkDerivation rec {
    name = "composer-${version}";
    version = "1.0.0-alpha11";

    src = pkgs.fetchurl {
      url = "https://getcomposer.org/download/${version}/composer.phar";
      sha256 = "1b41ad352p4296c2j7cdq27wp06w28080bjxnjpmw536scb7yd27";
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
    version = "2.3.4";

    src = pkgs.fetchurl {
      url = "https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${version}/phpcs.phar";
      sha256 = "ce11e02fba30a35a80b691b05be20415eb8b5dea585a4e6646803342b86abb8c";
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
