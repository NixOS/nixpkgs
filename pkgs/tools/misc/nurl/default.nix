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
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nurl";
    rev = "v${version}";
    hash = "sha256-cPbvYrMeARNi9b97EPUUzYN5j0YjenOCDdrdRVLBviw=";
  };

  cargoSha256 = "sha256-CBZe3UdTucgWrCzbXCSWjBjCNWCFUHmCpRwCXUX2sA8=";

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
