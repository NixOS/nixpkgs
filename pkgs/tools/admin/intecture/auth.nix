{ lib, fetchFromGitHub, rustPlatform
, openssl, zeromq, czmq, pkgconfig, cmake, zlib }:

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

  cargoSha256 = "17k4a3jd7n2fkalx7vvgah62pj77n536jvm17d60sj0yz2fxx799";

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkgconfig cmake ];

  meta = with lib; {
    description = "Authentication client/server for Intecture components";
    homepage = https://intecture.io;
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
