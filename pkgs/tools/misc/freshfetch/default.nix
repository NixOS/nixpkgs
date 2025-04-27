{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  AppKit,
  CoreFoundation,
  DiskArbitration,
  Foundation,
  IOKit,
}:

rustPlatform.buildRustPackage rec {
  pname = "freshfetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "k4rakara";
    repo = pname;
    rev = "v${version}";
    sha256 = "1l9zngr5l12g71j85iyph4jjri3crxc2pi9q0gczrrzvs03439mn";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LKltHVig33zUSWoRgCb1BgeKiJsDnlYEuPfQfrnhafI=";

  # freshfetch depends on rust nightly features
  RUSTC_BOOTSTRAP = 1;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    AppKit
    CoreFoundation
    DiskArbitration
    Foundation
    IOKit
  ];

  meta = with lib; {
    description = "Fresh take on neofetch";
    homepage = "https://github.com/k4rakara/freshfetch";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "freshfetch";
  };
}
