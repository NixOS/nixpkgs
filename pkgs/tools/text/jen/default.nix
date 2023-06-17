{ lib
, rustPlatform
, fetchCrate
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "jen";
  version = "1.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-fpv/IzU23yAz1cumTbdQP6wHJX2U4acNxq8Zrx+YQVs=";
  };

  cargoHash = "sha256-LKiPG7k5UgaESP1ShsIWNMnm9resbRje746txOBo+Qs=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "A simple CLI generation tool for creating large datasets";
    homepage = "https://github.com/whitfin/jen";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
