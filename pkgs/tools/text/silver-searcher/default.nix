{stdenv, fetchgit, autoreconfHook, pkgconfig, pcre, zlib, lzma}:

let release = "0.18.1"; in
stdenv.mkDerivation {
  name = "silver-searcher-${release}";

  src = fetchgit {
    url = "https://github.com/ggreer/the_silver_searcher.git";
    rev = "refs/tags/${release}";
    sha256 = "bf2c8f3c68895e0ee00d373c1d87201e806b413bb28373ee168e375f2a095ec5";
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
