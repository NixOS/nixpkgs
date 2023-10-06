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
  version = "0.12.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-mg0PkWxlfwo4eAtbU1ZOphEUBB1P6VsSpODyJZhvwQs=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  cargoHash = "sha256-6LXJtY844CyR6H0/IkEJrpSj4UNWcpO/XoTzUthcTUc=";

  meta = with lib; {
    homepage = "https://sea-ql.org/SeaORM";
    description = " Command line utility for SeaORM";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ traxys ];
  };
}
