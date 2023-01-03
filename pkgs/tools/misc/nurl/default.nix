{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, makeWrapper
, gitMinimal
, mercurial
, nix
}:

rustPlatform.buildRustPackage rec {
  pname = "nurl";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nurl";
    rev = "v${version}";
    hash = "sha256-fLa9gNdwBOSOMisU1UI8KAKGOkDN13LZsBpH+bObqUM=";
  };

  cargoSha256 = "sha256-vyhsZYYSpR2qbwTXOw8e1DFRQ78RVHktK6zCbiXT7RI=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

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
