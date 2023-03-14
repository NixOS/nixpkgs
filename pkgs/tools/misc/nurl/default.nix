{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, makeWrapper
, stdenv
, darwin
, gitMinimal
, mercurial
, nix
}:

rustPlatform.buildRustPackage rec {
  pname = "nurl";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nurl";
    rev = "v${version}";
    hash = "sha256-zImzwNBqNl1Ts3x3EDTfkMYe34j09u3xZDcLMv1DdcM=";
  };

  cargoSha256 = "sha256-avG/mXs3buWeaPqtjvVPrSeua4DqdiF1P6aCmdW0CUY=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # tests require internet access
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/nurl \
      --prefix PATH : ${lib.makeBinPath [ gitMinimal mercurial nix ]}
    installManPage artifacts/nurl.1
    installShellCompletion artifacts/nurl.{bash,fish} --zsh artifacts/_nurl
  '';

  GEN_ARTIFACTS = "artifacts";

  meta = with lib; {
    description = "Command-line tool to generate Nix fetcher calls from repository URLs";
    homepage = "https://github.com/nix-community/nurl";
    changelog = "https://github.com/nix-community/nurl/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
