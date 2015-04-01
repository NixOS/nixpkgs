{stdenv, fetchgit, autoreconfHook, pkgconfig, pcre, zlib, lzma}:

let release = "0.29.1"; in
stdenv.mkDerivation {
  name = "silver-searcher-${release}";

  src = fetchgit {
    url = "https://github.com/ggreer/the_silver_searcher.git";
    rev = "refs/tags/${release}";
    sha256 = "05508c2714d356464a0de6f41a6a8408ccd861b967e968302c4b72feade89581";
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
