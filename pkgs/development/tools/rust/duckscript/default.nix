{ lib
, stdenv
, runCommand
, fetchCrate
, rustPlatform
, Security
, openssl
, pkg-config
, SystemConfiguration
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "duckscript_cli";
  version = "0.9.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-2ouEmI7BH9J+PEN7l3rE8nmd0Khe2Bjq1Bg9SgGnB4E=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration libiconv ];

  cargoHash = "sha256-bBqcHETEWooMgQeqPOZIK/77DdTtGq1JusBKoRj5K6w=";

  meta = with lib; {
    description = "Simple, extendable and embeddable scripting language.";
    homepage = "https://github.com/sagiegurari/duckscript";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "duck";
  };
}
