{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libusb1,
  libftdi,
  cargo-readme,
  pkg-config,
  AppKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "humility";
  version = "unstable-2023-11-08";

  nativeBuildInputs = [
    pkg-config
    cargo-readme
  ];
  buildInputs =
    [
      libusb1
      libftdi
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      AppKit
    ];

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = pname;
    rev = "67d932edde8b32c11e5d6356a54e97d65f7b9b2b";
    sha256 = "sha256-3EVNlOAVfx/wUFn83VBKs1N5PanS4jVADUPlhCIok5M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-wuXlm6a0hz5E7lOQXlkjHTkD9tqU670uEBM6Gk4o+/Q=";

  meta = with lib; {
    description = "Debugger for Hubris";
    mainProgram = "humility";
    homepage = "https://github.com/oxidecomputer/humility";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ therishidesai ];
  };
}
