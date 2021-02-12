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

  cargoSha256 = "03x41s6d3shcwx9h36hv43d1sncbq7wn0ln59rp3arv8igsyqc2q";

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkg-config cmake ];

  meta = with lib; {
    description = "Authentication client/server for Intecture components";
    homepage = "https://intecture.io";
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
