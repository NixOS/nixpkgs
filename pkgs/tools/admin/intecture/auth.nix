{ lib, fetchFromGitHub, rustPlatform
, openssl, zeromq, czmq, pkg-config, cmake, zlib }:

with rustPlatform;

buildRustPackage rec {
  pname = "intecture-auth";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "intecture";
    repo = "auth";
    rev = version;
    sha256 = "0c7ar3pc7n59lzfy74lwz51p09s2bglc870rfr4c0vmc91jl0pj2";
  };

  cargoSha256 = "15f7lb0xxaxvhvj8g3kjmqy5jzy4pyzwk3zfdvykphpg18qgg6qj";

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkg-config cmake ];

  meta = with lib; {
    description = "Authentication client/server for Intecture components";
    homepage = "https://intecture.io";
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
