{ stdenv, fetchFromGitHub
, pkgconfig, cmake, xxd
, openssl, libwebsockets, json_c, libuv, zlib
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "ttyd";
  version = "1.6.1";
  src = fetchFromGitHub {
    owner = "tsl0922";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "1ifgw93g8jaaa6fgfqjnn83n5ccr6l72ynwwwa97hfwjk90r14fg";
  };

  nativeBuildInputs = [ pkgconfig cmake xxd ];
  buildInputs = [ openssl libwebsockets json_c libuv zlib ];
  enableParallelBuilding = true;

  outputs = [ "out" "man" ];

  meta = {
    description = "Share your terminal over the web";
    homepage    = "https://github.com/tsl0922/ttyd";
    license     = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
