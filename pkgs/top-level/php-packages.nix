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
      md5 = "e5816d47d52be200b959bf69a673ff74";
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
}; in self
