{
  lib,
  rustPlatform,
  stdenv,
  fetchCrate,
  pkg-config,
  openssl,
  capnproto,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "flowgger";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eybahv1A/AIpAXGj6/md8k+b9fu9gSchU16fnAWZP2s=";
  };

  cargoHash = "sha256-DZGyX3UDqCjB5NwCXcR8b9pXdq8qacd3nkqGp6vYb+U=";

  nativeBuildInputs = [
    pkg-config
    capnproto
  ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.isDarwin CoreServices;

  checkFlags = [
    # test failed
    "--skip=flowgger::encoder::ltsv_encoder::test_ltsv_full_encode_multiple_sd"
    "--skip=flowgger::encoder::ltsv_encoder::test_ltsv_full_encode_no_sd"
  ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/flowgger";
    description = "A fast, simple and lightweight data collector written in Rust";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    mainProgram = "flowgger";
  };
}
