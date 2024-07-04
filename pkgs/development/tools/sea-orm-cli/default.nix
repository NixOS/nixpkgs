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
  version = "0.12.15";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eRsWQXaE8zzECPY+xxVIwTylbuSPT6ABamI4WNVkw8M=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  cargoHash = "sha256-sIyKkTO2DSLkRAlSUSRQYrZb8UtKZrszjn2jELNOSOU=";

  meta = with lib; {
    homepage = "https://www.sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys ];
  };
}
