{ lib, stdenv, fetchFromGitHub
, pkg-config, cmake, xxd
, openssl, libwebsockets, json_c, libuv, zlib
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "ttyd";
  version = "1.7.3";
  src = fetchFromGitHub {
    owner = "tsl0922";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-zwKK8TPEATAgJwHh04hurzU3NrhyHA70qkf5kXW1yQc=";
  };

  nativeBuildInputs = [ pkg-config cmake xxd ];
  buildInputs = [ openssl libwebsockets json_c libuv zlib ];

  outputs = [ "out" "man" ];

  meta = {
    description = "Share your terminal over the web";
    homepage    = "https://github.com/tsl0922/ttyd";
    license     = lib.licenses.mit;
    maintainers = [ lib.maintainers.thoughtpolice ];
    platforms   = lib.platforms.all;
  };
}
