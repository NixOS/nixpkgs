{ stdenv, fetchFromGitHub
, pkgconfig, cmake, xxd
, openssl, libwebsockets, json_c, libuv, zlib
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "ttyd";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "tsl0922";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "08skw3h897jb71sbnglj571h35pcb1mikzlh71sx5imjgi4hfczr";
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
