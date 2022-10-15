{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, libusb1
, libiconv
, AppKit
, IOKit
}:

rustPlatform.buildRustPackage rec {
  pname = "probe-run";
  version = "0.3.5";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-C9JxQVsS1Bv9euQ7l+p5aehiGLKdrUMcno9z8UoZKR4=";
  };

  cargoSha256 = "sha256-kmdRwAq6EOniGHC7JhB6Iov1E4hbQbxHlOcc6gUDOhY=";

  nativeBuildInputs = [
    pkg-config
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
