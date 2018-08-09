{ stdenv, fetchFromGitHub
, pkgconfig, cmake
, libressl, libuv, zlib
}:

with builtins;

stdenv.mkDerivation rec {
  name = "h2o-${version}";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner  = "h2o";
    repo   = "h2o";
    rev    = "refs/tags/v${version}";
    sha256 = "0jyvbp6cjiirj44nxqa2fi5y473gnc8awfn8zv82hb1y9rlxqfyv";
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
