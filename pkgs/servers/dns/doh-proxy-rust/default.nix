{ lib, rustPlatform, fetchCrate, stdenv, Security, libiconv, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "doh-proxy-rust";
  version = "0.9.7";

  src = fetchCrate {
    inherit version;
    crateName = "doh-proxy";
    sha256 = "sha256-rcLI5sLdqelnpfU7/T0s0l3rtpYBd77BBAXc4xSmCCE=";
  };

  cargoHash = "sha256-zkZuyegz82xOBq2t0jkMo6SLLteOHuhrFcROZCQeiyk=";

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
