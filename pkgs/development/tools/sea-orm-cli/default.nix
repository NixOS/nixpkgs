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
  version = "0.11.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-VRSdPsjRubJOsjdAxdnFCM9VmAVwGkXDvpXT4GF2jxY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  cargoHash = "sha256-4lPtj11Gc+0r2WQT8gx8eX+YK5L+HnUBR0w6pm3VlRQ=";

  meta = with lib; {
    homepage = "https://sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys ];
  };
}
