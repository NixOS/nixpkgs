{ lib
, stdenv
, fetchurl
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
  version = "0.8.14";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-3LsHgn4FeukQXkEVG7V3wJlH+0Ut2cQQSQDrLMhc7qw=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration libiconv ];

  cargoSha256 = "sha256-SiuDKH1jXU6m9MfQ9W3GxXVMkxOxB1Y3zn0Iz8zR7Zs=";

  meta = with lib; {
    description = "Simple, extendable and embeddable scripting language.";
    homepage = "https://github.com/sagiegurari/duckscript";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "duck";
  };
}
