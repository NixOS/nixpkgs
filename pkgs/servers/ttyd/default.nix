{ lib, stdenv, fetchFromGitHub
, pkg-config, cmake, xxd
, openssl, libwebsockets, json_c, libuv, zlib
}:

with builtins;

stdenv.mkDerivation rec {
  pname = "ttyd";
  version = "1.7.1";
  src = fetchFromGitHub {
    owner = "tsl0922";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-eUddAo9gGL/Uzf9r54U4AKW49Otr8gr+YQXwJS60Eo8=";
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
