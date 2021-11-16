{ lib, stdenv, fetchCrate, rustPlatform, openssl, pkg-config, Security }:

rustPlatform.buildRustPackage rec {
  pname = "apkeep";
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-RTzYvDkmE0kgl4FSOSjDuQ5G1E0ugFU41zVAMMroofM=";
  };

  cargoSha256 = "sha256-YFs2AOMGp0WNrceK14AnigZdJl+UsQdUchpxaI7HSXw=";

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
