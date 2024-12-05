{ lib, rustPlatform, fetchCrate, stdenv, Security, libiconv, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "doh-proxy-rust";
  version = "0.9.11";

  src = fetchCrate {
    inherit version;
    crateName = "doh-proxy";
    hash = "sha256-h2LwxqyyBPAXRr6XOmcLEmbet063kkM1ledULp3M2ek=";
  };

  cargoHash = "sha256-eXPAn2ziSdciZa6YrOIa7y7Lms681X+yVAD9HrvsZHg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security libiconv ];

  passthru.tests = { inherit (nixosTests) doh-proxy-rust; };

  meta = with lib; {
    homepage = "https://github.com/jedisct1/doh-server";
    description = "Fast, mature, secure DoH server proxy written in Rust";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ stephank ];
    mainProgram = "doh-proxy";
  };
}
