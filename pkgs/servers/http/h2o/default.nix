{ stdenv, fetchFromGitHub
, pkgconfig, cmake
, libressl, libuv, zlib
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "h2o";
  version = "2.2.6";

  src = fetchFromGitHub {
    owner  = "h2o";
    repo   = "h2o";
    rev    = "refs/tags/v${version}";
    sha256 = "0qni676wqvxx0sl0pw9j0ph7zf2krrzqc1zwj73mgpdnsr8rsib7";
  };

  # We have to fix up some function prototypes, because despite upstream h2o
  # issue #1705 (https://github.com/h2o/h2o/issues/1706), libressl 2.7+ doesn't
  # seem to work
  patchPhase = ''
    substituteInPlace ./deps/neverbleed/neverbleed.c \
      --replace 'static void RSA_' 'void RSA_' \
      --replace 'static int RSA_'  'int RSA_'
  '';

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ libressl libuv zlib ];
  enableParallelBuilding = true;

  meta = {
    description = "Optimized HTTP/1 and HTTP/2 server";
    homepage    = https://h2o.examp1e.net;
    license     = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
