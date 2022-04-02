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
  version = "0.8.10";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-cMvcCX8ViCcUFMuxAPo3/wxXvg5swAcBrLx1x7lSwvM=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security SystemConfiguration libiconv ];

  cargoSha256 = "sha256-8ywMLXFmdq119K/hl1hpsVhzG+nrdO4eux3lAqUjB+A=";

  meta = with lib; {
    description = "Simple, extendable and embeddable scripting language.";
    homepage = "https://github.com/sagiegurari/duckscript";
    license = licenses.asl20;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
