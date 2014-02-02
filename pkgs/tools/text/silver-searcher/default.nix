{stdenv, fetchgit, autoreconfHook, pkgconfig, pcre, zlib, lzma}:

let release = "0.19.1"; in
stdenv.mkDerivation {
  name = "silver-searcher-${release}";

  src = fetchgit {
    url = "https://github.com/ggreer/the_silver_searcher.git";
    rev = "refs/tags/${release}";
    sha256 = "1km3ap74mls7vkp6si4f302zb1ifmldipjyfw2z9akqpvr3n44p9";
  };

  buildInputs = [ autoreconfHook pkgconfig pcre zlib lzma ];

  meta = {
    homepage = https://github.com/ggreer/the_silver_searcher/;
    description = "A code-searching tool similar to ack, but faster";
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.asl20;
  };
}
