{ lib, stdenv, rustPlatform, fetchurl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trinsic-cli";
  version = "1.13.0";

  src = fetchurl {
    url = "https://github.com/trinsic-id/sdk/releases/download/v${version}/trinsic-cli-vendor-${version}.tar.gz";
    sha256 = "sha256-uW4PNlDfyxzec9PzfXr25gPrFZQGr8qm0jLMOeIazoE=";
  };

  cargoVendorDir = "vendor";
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Trinsic CLI";
    longDescription = ''
      Command line interface for Trinsic Ecosystems
    '';
    homepage = "https://trinsic.id/";
    license = licenses.asl20;
    maintainers = with maintainers; [ tmarkovski ];
    mainProgram = "trinsic";
  };
}
