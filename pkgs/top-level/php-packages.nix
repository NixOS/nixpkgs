{ pkgs, php }:

let self = with self; {
  buildPecl = import ../build-support/build-pecl.nix {
    inherit php;
    inherit (pkgs) stdenv autoreconfHook fetchurl;
  };

  memcache = buildPecl {
    name = "memcache-3.0.8";

    sha256 = "04c35rj0cvq5ygn2jgmyvqcb0k8d03v4k642b6i37zgv7x15pbic";

    configureFlags = "--with-zlib-dir=${pkgs.zlib}";
  };

  memcached = buildPecl {
    name = "memcached-2.1.0";

    sha256 = "1by4zhkq4mbk9ja6s0vlavv5ng8aw5apn3a1in84fkz7bc0l0jdw";

    configureFlags = [
      "--with-zlib-dir=${pkgs.zlib}"
      "--with-libmemcached-dir=${pkgs.libmemcached}"
    ];

    buildInputs = [ pkgs.cyrus_sasl ];
  };

  xdebug = buildPecl {
    name = "xdebug-2.2.5";

    sha256 = "0vss35da615709kdvqji8pblckfvmabmj2njjjz6h8zzvj9gximd";
  };

  apc = buildPecl {
    name = "apc-3.1.13";

    sha256 = "1gcsh9iar5qa1yzpjki9bb5rivcb6yjp45lmjmp98wlyf83vmy2y";
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

    version = "3.1.0";

    src = pkgs.fetchurl {
      url = "http://xcache.lighttpd.net/pub/Releases/${version}/${name}.tar.bz2";
      sha256 = "1saysvzwkfmcyg53za4j7qnranxd6871spjzfpclhdlqm043xbw6";
    };

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
    name = "redis-2.2.5";

    sha256 = "0hrk0lf8h6l30zrjld29csl186zb1cl2rz1gfn9dma33np4iisyw";
  };

  composer = pkgs.stdenv.mkDerivation rec {
    name = "composer-${version}";
    version = "1.0.0-alpha9";

    src = pkgs.fetchurl {
      url = "https://getcomposer.org/download/1.0.0-alpha9/composer.phar";
      sha256 = "1x7i9xs9xggq0qq4kzrwh2pky8skax0l829zwwsy3hcvch3irvrk";
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
      maintainers = with maintainers; [offline];
    };
  };
}; in self
