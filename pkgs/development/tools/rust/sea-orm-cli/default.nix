{ lib, stdenv, fetchCrate, openssl, pkg-config, rustPlatform
, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-OEsUNicNRfXUctpuVAb/3Raa+x6qeg9Mtx9FtHzBcjw=";
  };

  cargoSha256 = "sha256-aiUk+3Ppn+AgezNnK7s3AlmFTduH8stg3oxHbbczBE0=";

  cargoBuildFlags = [ "--bin" pname ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://www.sea-ql.org/SeaORM";
    description =
      "SeaORM is a relational ORM to help you build web services in Rust with the familiarity of dynamic languages";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "sea-orm-cli";
  };
}
