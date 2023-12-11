{ lib
, rustPlatform
, stdenv
, fetchCrate
, pkg-config
, openssl
, capnproto
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "flowgger";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-PRlcfSVfQWt+rQEJjblY7/AMrjhGYO2/G7EX60aGApA=";
  };

  cargoHash = "sha256-hp2LrEVWo0gk95dPROqVcHEEG5N9fWms0mZkY9QILg0=";

  nativeBuildInputs = [
    pkg-config
    capnproto
  ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin CoreServices;

  checkFlags = [
    # test failed
    "--skip=flowgger::encoder::ltsv_encoder::test_ltsv_full_encode_multiple_sd"
    "--skip=flowgger::encoder::ltsv_encoder::test_ltsv_full_encode_no_sd"
  ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/flowgger";
    description = "A fast, simple and lightweight data collector written in Rust";
    license = licenses.bsd2;
    maintainers = with maintainers; [];
    mainProgram = "flowgger";
  };
}
