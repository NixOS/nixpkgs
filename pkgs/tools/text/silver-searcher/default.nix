{stdenv, fetchgit, autoreconfHook, pkgconfig, pcre, zlib, lzma}:

let release = "0.19.2"; in
stdenv.mkDerivation {
  name = "silver-searcher-${release}";

  src = fetchgit {
    url = "https://github.com/ggreer/the_silver_searcher.git";
    rev = "refs/tags/${release}";
    sha256 = "b6993e077f650eb0976cbc924640665fa9b2499a899ecba5a6cad5cf9addfdff";
  };

  NIX_LDFLAGS = "-lgcc_s";

  buildInputs = [ autoreconfHook pkgconfig pcre zlib lzma ];

  meta = {
    homepage = https://github.com/ggreer/the_silver_searcher/;
    description = "A code-searching tool similar to ack, but faster";
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.asl20;
  };
}
