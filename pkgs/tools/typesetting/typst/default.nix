{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "typst";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "typst";
    repo = "typst";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-q2b/PoNwpzarJbIPzokYgZRD2/Oe/XB40C4VXdwL/NA=";
=======
    hash = "sha256-Sx4HWs52WycAxAuoJyo8t83CxnMh64P94hbPiedfztc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "iai-0.1.1" = "sha256-EdNzCPht5chg7uF9O8CtPWR/bzSYyfYIXNdLltqdlR0=";
<<<<<<< HEAD
      "oxipng-8.0.0" = "sha256-KIbSsQEjwJ12DxYpBTUD1g9CqJqCfSAmnFcSTiGIoio=";
      "self-replace-1.3.5" = "sha256-N57nmLHgxhVR1CDtkgjYwpo1ypdGyVpjJY7vzuncxDc=";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  env = {
    GEN_ARTIFACTS = "artifacts";
  };

  postInstall = ''
<<<<<<< HEAD
    installManPage crates/typst-cli/artifacts/*.1
    installShellCompletion \
      crates/typst-cli/artifacts/typst.{bash,fish} \
      --zsh crates/typst-cli/artifacts/_typst
=======
    installManPage cli/artifacts/*.1
    installShellCompletion \
      cli/artifacts/typst.{bash,fish} \
      --zsh cli/artifacts/_typst
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "A new markup-based typesetting system that is powerful and easy to learn";
    homepage = "https://typst.app";
    changelog = "https://github.com/typst/typst/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ drupol figsoda kanashimia ];
<<<<<<< HEAD
    mainProgram = "typst";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
