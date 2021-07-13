{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, rustPlatform
, AppKit
, CoreFoundation
, DiskArbitration
, Foundation
, IOKit
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

  cargoLock = {
    # update Cargo.lock every new release of freshfetch
    lockFile = ./Cargo.lock;
    outputHashes = {
      "clml_rs-0.3.0" = "0hvd59zh7czk9jd1a2wwcm1acpcfbz32v9ka7ap6f74d638jcc19";
    };
  };

  # freshfetch depends on rust nightly features
  RUSTC_BOOTSTRAP = 1;

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    CoreFoundation
    DiskArbitration
    Foundation
    IOKit
  ];

  meta = with lib; {
    description = "A fresh take on neofetch";
    homepage = "https://github.com/k4rakara/freshfetch";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
