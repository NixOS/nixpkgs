{ stdenv, fetchFromGitHub
, pkgconfig, cmake, xxd
, openssl, libwebsockets, json_c, libuv
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "ttyd";
  version = "1.5.2";
  src = fetchFromGitHub {
    owner = "tsl0922";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "16nngc3dqrsgpapzvl34c0msgdd1fyp3k8r1jj1m9bch6z2p50bl";
  };

  nativeBuildInputs = [ pkgconfig cmake xxd ];
  buildInputs = [ openssl libwebsockets json_c libuv ];
  enableParallelBuilding = true;

  outputs = [ "out" "man" ];

  meta = {
    description = "Share your terminal over the web";
    homepage    = https://github.com/tsl0922/ttyd;
    license     = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
    platforms   = stdenv.lib.platforms.linux;
  };
}
