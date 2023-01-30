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
  version = "0.3.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-HYFVdj1kASu+VKnDJA35zblPsgUeYC9YVlS84Hkx1Sk=";
  };

  cargoSha256 = "sha256-nhs9qNFd1GK70sL5sPPeMazuPUP67epHayXnw3aXTfk=";

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
    homepage = "https://github.com/knurling-rs/probe-run";
    changelog = "https://github.com/knurling-rs/probe-run/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ hoverbear newam ];
  };
}
