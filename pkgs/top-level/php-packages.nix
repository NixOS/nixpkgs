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
}; in self
