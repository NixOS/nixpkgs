{ lib, rustPlatform, fetchCrate, stdenv, Security, libiconv, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "doh-proxy-rust";
  version = "0.9.8";

  src = fetchCrate {
    inherit version;
    crateName = "doh-proxy";
    sha256 = "sha256-+Z2eneEK6nhcJEKRa1VIolCTZ8to2mMQ8Ik7WEH+1w0=";
  };

  cargoHash = "sha256-nlKzVQeLg3/nBIkD7QoBUWC93m9BiJrybf13Y/ns9gA=";

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
