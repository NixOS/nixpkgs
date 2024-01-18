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
  version = "0.9.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qvocz/7Fx2YkgPcOYQha5iHQmoU40joGamj/SMiYx+4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration libiconv ];

  cargoHash = "sha256-SW3Q/+EhdMNLbhGQPpiIXuJv3ttyeCpjjvbVCrJzXlY=";

  meta = with lib; {
    description = "Simple, extendable and embeddable scripting language.";
    homepage = "https://github.com/sagiegurari/duckscript";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
    mainProgram = "duck";
  };
}
