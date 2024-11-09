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
  version = "1.0.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-b1Nlt3vsLDajTiIW9Vn51Tv9gXja8/ZZBD62iZjh3KY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  cargoHash = "sha256-ZGM+Y67ycBiukgEBUq+WiA1OUCGahya591gM6CGwzMQ=";

  meta = with lib; {
    homepage = "https://www.sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys NikaidouHaruki ];
  };
}
