{ stdenv, fetchFromGitHub
, pkgconfig, cmake
, libressl_2_6, libuv, zlib
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
