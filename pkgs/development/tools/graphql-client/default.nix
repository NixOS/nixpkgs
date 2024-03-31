{ lib, stdenv, rustPlatform, fetchCrate, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "graphql-client";
  version = "0.13.0";

  src = fetchCrate {
    inherit version;
    crateName = "graphql_client_cli";
    sha256 = "sha256-eQ+7Ru3au/rDQZtwFDXYyybqC5uFtNBs6cEzX2QSFI4=";
  };

  cargoSha256 = "sha256-fEjt7ax818hlIq2+UrIG6EismQUGdaq7/C3xN+Nrw2s=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A GraphQL tool for Rust projects";
    mainProgram = "graphql-client";
    homepage = "https://github.com/graphql-rust/graphql-client";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ bbigras ];
  };
}
