{stdenv, fetchgit, autoreconfHook, pkgconfig, pcre, zlib, lzma}:

let release = "0.24.1"; in
stdenv.mkDerivation {
  name = "silver-searcher-${release}";

  src = fetchgit {
    url = "https://github.com/ggreer/the_silver_searcher.git";
    rev = "refs/tags/${release}";
    sha256 = "1cwav217mkbwyg8isiak0wynydiil2j9gy4sx79harbcql0f3nl3";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  buildInputs = [ autoreconfHook pkgconfig pcre zlib lzma ];

  meta = {
    homepage = https://github.com/ggreer/the_silver_searcher/;
    description = "A code-searching tool similar to ack, but faster";
    maintainers = [ stdenv.lib.maintainers.madjar ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.asl20;
  };
}
