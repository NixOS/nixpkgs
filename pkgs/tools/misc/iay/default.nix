{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "iay";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-xp+9WmzvuYf7vfNGTc/ZQ/fF8UsprS3S1SBHPYX/5fg=";
  };

  cargoSha256 = "sha256-SMqiwM6LrXXjV4Mb2BY9WbeKKPkxiYxPyZ4aepVIAqU=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Minimalistic shell prompt";
    homepage = "https://github.com/aaqaishtyaq/iay";
    license = licenses.mit;
    maintainers = with maintainers; [ omasanori ];
    platforms = platforms.unix;
  };
}
