{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, darwin
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "0.12.10";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-BVQbzP/+TJFqhnBeerYiLMpJJ8q9x582DR5X10K027U=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  cargoHash = "sha256-qCcWReo72eHN9MoTVAmSHYVhpqw0kZ9VU/plYRcirVA=";

  meta = with lib; {
    homepage = "https://www.sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys ];
  };
}
