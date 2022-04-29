{ lib, stdenv, fetchCrate, rustPlatform, openssl, pkg-config, Security }:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.11.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-kwJ4/jkVVgem5Lb+uFDFPk4/6WWSWJs+SQDSyKkhG/8=";
  };

  cargoSha256 = "sha256-kJ81kY2EmkH3yu8xL1aPxXPMhkDsGKWo0RWn1Ih7z2k=";

  prePatch = ''
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A command-line tool for downloading APK files from various sources";
    homepage = "https://github.com/EFForg/apkeep";
    license = licenses.mit;
    maintainers = with maintainers; [ jyooru ];
  };
}
