{ stdenv, fetchFromGitHub
, pkgconfig, cmake
, libressl_2_6, libuv, zlib
}:

with builtins;

stdenv.mkDerivation rec {
  name = "h2o-${version}";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner  = "h2o";
    repo   = "h2o";
    rev    = "refs/tags/v${version}";
    sha256 = "0176x0bzjry19zs074a9i5vhncc842xikmx43wj61jky318nq4w4";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ libressl_2_6 libuv zlib ];
  enableParallelBuilding = true;

  meta = {
    description = "Optimized HTTP/1 and HTTP/2 server";
    homepage    = https://h2o.examp1e.net;
    license     = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
