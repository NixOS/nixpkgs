{ lib
, stdenv
, fetchCrate
, rustPlatform
, pkg-config
<<<<<<< HEAD
, rustfmt
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, openssl
, CoreServices
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pdf";
<<<<<<< HEAD
  version = "0.1.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-3hyvLLBcS7MLAL707tkvW8LGue/x9DudOYhJDDqAdRg=";
  };

  cargoHash = "sha256-ecIaKSrkqUsQWchkm9uCTXLuQabzGmEz1UqDR13vX8Y=";

  nativeBuildInputs = [
    pkg-config
    rustfmt
=======
  version = "0.1.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-822RQKgedxQ+VFNDv20tFUc2Xl56Ivub+/EXNrLRfGM=";
  };

  cargoHash = "sha256-mX2EKjuWM1KW8DXFdYFKQfASjdqZCW78F1twZNQQr7o=";

  nativeBuildInputs = [
    pkg-config
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

<<<<<<< HEAD
  # Stop downloading from the Internet to
  # generate the Chrome Devtools Protocol
  DOCS_RS=true;

  # # Stop formating with rustfmt, pending version update for
  # # https://github.com/mdrokz/auto_generate_cdp/pull/8
  # # to remove rustfmt dependency
  # DO_NOT_FORMAT=true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # No test.
  doCheck = false;

  meta = with lib; {
    description = "A backend for mdBook written in Rust for generating PDF";
    homepage = "https://github.com/HollowMan6/mdbook-pdf";
    changelog = "https://github.com/HollowMan6/mdbook-pdf/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 ];
  };
}
