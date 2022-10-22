{ lib, rustPlatform, fetchCrate, stdenv, Security, libiconv, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "doh-proxy-rust";
  version = "0.9.4";

  src = fetchCrate {
    inherit version;
    crateName = "doh-proxy";
    sha256 = "sha256-IuLNgyPiAPYu440jMtpXxEuQDIn9TUMjnD7y8WB+Ujs=";
  };

  cargoSha256 = "sha256-qrLhRNaGG7n9UPtkqNkJvnf+w9P0iLQ7MkIxnWYqYLM=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  passthru.tests = { inherit (nixosTests) doh-proxy-rust; };

  meta = with lib; {
    homepage = "https://github.com/jedisct1/doh-server";
    description = "Fast, mature, secure DoH server proxy written in Rust";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ stephank ];
    mainProgram = "doh-proxy";
  };
}
