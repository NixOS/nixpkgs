{ pkgs, php }:

let self = with self; {
  buildPecl = import ../build-support/build-pecl.nix {
    inherit php;
    inherit (pkgs) stdenv autoreconfHook;
  };

  memcache = buildPecl {
    name = "memcache-3.0.8";

    src = pkgs.fetchurl {
      url = http://pecl.php.net/get/memcache-3.0.8.tgz;
      sha256 = "04c35rj0cvq5ygn2jgmyvqcb0k8d03v4k642b6i37zgv7x15pbic";
    };

    configureFlags = "--with-zlib-dir=${pkgs.zlib}";
  };

  memcached = buildPecl {
    name = "memcached-2.1.0";

    src = pkgs.fetchurl {
      url = http://pecl.php.net/get/memcached-2.1.0.tgz;
      sha256 = "1by4zhkq4mbk9ja6s0vlavv5ng8aw5apn3a1in84fkz7bc0l0jdw";
    };

    configureFlags = [
      "--with-zlib-dir=${pkgs.zlib}"
      "--with-libmemcached-dir=${pkgs.libmemcached}"
    ];

    buildInputs = [ pkgs.cyrus_sasl ];
  };
}; in self
