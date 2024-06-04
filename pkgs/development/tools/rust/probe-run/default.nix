{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, DarwinTools
, libusb1
, libiconv
, AppKit
, IOKit
}:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.3.11";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-RlmN2PV5Z/+NTYia7LhrAW437bsg6oUxlQ1qcbZuq0o=";
  };

  cargoHash = "sha256-MG3xHArNEqXs0vC5sSyaBM3421yJ25nazvBNQVcs4v0=";

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [
    DarwinTools
  ];

  buildInputs = [
    libusb1
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    AppKit
    IOKit
  ];

  meta = with lib; {
    description = "Run embedded programs just like native ones";
    mainProgram = "probe-run";
    homepage = "https://github.com/knurling-rs/probe-run";
    changelog = "https://github.com/knurling-rs/probe-run/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ hoverbear newam ];
  };
}
