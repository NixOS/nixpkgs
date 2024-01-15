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
  version = "0.22.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Pb7Df3JI6ACcJ81+9KZ8qMM5Y/VT0kO5kubC3g0Wtlk=";
  };

  cargoHash = "sha256-Wb+ZPUrNA3LW4huT1QnyW8RKkh4Ow6gBT1VByHlEwGg=";

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
