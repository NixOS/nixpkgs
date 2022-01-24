{ lib, rustPlatform, fetchCrate, stdenv, Security, libiconv, nixosTests }:

rustPlatform.buildRustPackage rec {
  pname = "doh-proxy-rust";
  version = "0.9.2";

  src = fetchCrate {
    inherit version;
    crateName = "doh-proxy";
    sha256 = "sha256-/637lR6OycVOOUVe29uFR1LtYIoFJ6gslDV9uAGkU1A=";
  };

  cargoSha256 = "sha256-tadTyWSuknAjosv7AvZF0/8FlHL/zcFT5LDW1KcMeHI=";

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
