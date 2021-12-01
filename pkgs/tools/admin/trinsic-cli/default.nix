{ lib, stdenv, rustPlatform, fetchurl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "trinsic-cli";
  version = "1.1.2";

  src = fetchurl {
    url = "https://github.com/trinsic-id/sdk/releases/download/v${version}/trinsic-cli-vendor-${version}.tar.gz";
    sha256 = "7e5377e8460ebb1253b9974e02d0077ffc58f2b4712cf7896f1bef7e9f580cd4";
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
  };
}
