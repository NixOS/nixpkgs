{ lib, fetchFromGitHub, rustPlatform
, openssl, zeromq, czmq, pkgconfig, cmake, zlib }:

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

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "093ipd8lg2ngnln55x5j40g2n8f3y8aysgz9rjn95a4npxrg4yxw";

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkgconfig cmake ];

  meta = with lib; {
    description = "Authentication client/server for Intecture components";
    homepage = https://intecture.io;
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
