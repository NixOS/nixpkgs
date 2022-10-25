{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "sagoin";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cp3sdck48kz7ssv9q0glz1m0awxis2n3lw8f8kvqm42zxa50ixm";
  };

  cargoSha256 = "sha256-hPj1sj64JoIGEoHMIm2bE+G+ivokckvChhrxNoaUTo8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    installManPage artifacts/sagoin.1
    installShellCompletion artifacts/sagoin.{bash,fish} --zsh artifacts/_sagoin
  '';

  GEN_ARTIFACTS = "artifacts";

  meta = with lib; {
    description = "A command-line submission tool for the UMD CS Submission Server";
    homepage = "https://github.com/figsoda/sagoin";
    changelog = "https://github.com/figsoda/sagoin/blob/v${version}/CHANGELOG.md";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
