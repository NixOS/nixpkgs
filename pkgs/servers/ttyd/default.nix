{ stdenv, fetchFromGitHub
, pkgconfig, cmake, xxd
, openssl, libwebsockets, json_c, libuv
}:

with builtins;

let
  # ttyd hasn't seen a release in quite a while. remove all this
  # junk when a new one happens (eventually)
  revCount = 174;
  src = fetchFromGitHub {
    owner  = "tsl0922";
    repo   = "ttyd";
    rev    = "6df6ac3e03b705ddd46109c2ac43a1cba439c0df";
    sha256 = "0g5jlfa7k6qd59ysdagczlhwgjfjspb3sfbd8b790hcil933qrxm";
  };

in stdenv.mkDerivation rec {
  name = "ttyd-${version}";
  version = "1.4.2_pre${toString revCount}_${substring 0 8 src.rev}";
  inherit src;

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
