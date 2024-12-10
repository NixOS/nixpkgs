{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  stdenv,
  darwin,
  gitMinimal,
  mercurial,
  nix,
}:

rustPlatform.buildRustPackage rec {
  pname = "nurl";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nurl";
    rev = "v${version}";
    hash = "sha256-rVqF+16esE27G7GS55RT91tD4x/GAzfVlIR0AgSknz0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "nix-compat-0.1.0" = "sha256-xHwBlmTggcZBFSh4EOY888AbmGQxhwvheJSStgpAj48=";
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
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
          mercurial
          nix
        ]
      }
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
    mainProgram = "nurl";
  };
}
