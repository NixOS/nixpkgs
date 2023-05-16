{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, makeBinaryWrapper
, stdenv
, darwin
, gitMinimal
, mercurial
<<<<<<< HEAD
, nix
=======
, nixVersions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "nurl";
<<<<<<< HEAD
  version = "0.3.13";
=======
  version = "0.3.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nurl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rVqF+16esE27G7GS55RT91tD4x/GAzfVlIR0AgSknz0=";
=======
    hash = "sha256-erIC7JAluPs/ToXxjpSpSI6vB1hJVXywQTT+aARenOc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "nix-compat-0.1.0" = "sha256-xHwBlmTggcZBFSh4EOY888AbmGQxhwvheJSStgpAj48=";
=======
      "nix-compat-0.1.0" = "sha256-J9MedxcVcH5DdRxdqD8cb5YRC/SjZ0vQTCFBMLVMQPo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # tests require internet access
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/nurl \
<<<<<<< HEAD
      --prefix PATH : ${lib.makeBinPath [ gitMinimal mercurial nix ]}
=======
      --prefix PATH : ${lib.makeBinPath [ gitMinimal mercurial nixVersions.unstable ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    installManPage artifacts/nurl.1
    installShellCompletion artifacts/nurl.{bash,fish} --zsh artifacts/_nurl
  '';

  env = {
    GEN_ARTIFACTS = "artifacts";
  };

  meta = with lib; {
    description = "Command-line tool to generate Nix fetcher calls from repository URLs";
    homepage = "https://github.com/nix-community/nurl";
    changelog = "https://github.com/nix-community/nurl/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
<<<<<<< HEAD
    mainProgram = "nurl";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
