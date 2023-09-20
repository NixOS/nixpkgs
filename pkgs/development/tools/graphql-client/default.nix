{ lib, stdenv, rustPlatform, fetchCrate, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "graphql-client";
  version = "0.10.0";

  src = fetchCrate {
    inherit version;
    crateName = "graphql_client_cli";
    sha256 = "sha256-OV4kpvciEJOGfhkxPoNf1QmhdytWMhXuQAKOFJvDFA4=";
  };

  cargoSha256 = "sha256-r/pRwDLc/yGMzdZIx8SV46o63eb6qrlTb6MsUBhq97w=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A GraphQL tool for Rust projects";
    homepage = "https://github.com/graphql-rust/graphql-client";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ bbigras ];
  };
}
