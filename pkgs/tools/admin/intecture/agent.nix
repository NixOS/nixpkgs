{ lib, fetchFromGitHub, rustPlatform
, openssl, zeromq, czmq, pkg-config, cmake, zlib }:

with rustPlatform;

buildRustPackage rec {
  pname = "intecture-agent";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "intecture";
    repo = "agent";
    rev = version;
    sha256 = "0j27qdgyxybaixggh7k57mpm6rifimn4z2vydk463msc8b3kgywj";
  };

  cargoSha256 = "0zlj3yhqa9nhvmr9ykv6mjpixsj43k4k1kkk4f16404yn3wx0b8k";

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkg-config cmake ];

  meta = with lib; {
    description = "Authentication client/server for Intecture components";
    homepage = "https://intecture.io";
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
