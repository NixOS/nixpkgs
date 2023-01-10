{ lib, rustPlatform, fetchCrate, stdenv, Security, libiconv, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "doh-proxy-rust";
  version = "0.9.6";

  src = fetchCrate {
    inherit version;
    crateName = "doh-proxy";
    sha256 = "sha256-7eKqCiafzmwk0suH8GviRVBmmvhBd5/R4aF9cSvSyNU=";
  };

  cargoHash = "sha256-+IlVjordlMgf8srXtQVLMXRbYs+4htDP+NToVXxPqR4=";

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
