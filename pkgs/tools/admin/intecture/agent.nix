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

  cargoSha256 = "0j7yv00ipaa60hpakfj60xrblcyzjwi0lp2hpzz41vq3p9bkigvm";

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkg-config cmake ];

  meta = with lib; {
    description = "Authentication client/server for Intecture components";
    homepage = "https://intecture.io";
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
