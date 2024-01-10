{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, libusb1
, DarwinTools
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "rtthost";
  version = "0.21.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Vp2TXKDr6Mu4CD6RlHjTL04FIShzKXwNZmu0PIqx1FY=";
  };

  cargoHash = "sha256-XRxijak3kBMYCx9u39OWvqz3tjnKipjcV3DPEUBYrvQ=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isDarwin [ DarwinTools ];

  buildInputs = [ libusb1 ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "RTT (Real-Time Transfer) client";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ samueltardieu ];
  };
}
