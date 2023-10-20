{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.6.0";
  vendorHash = "sha256-1BqgnWFMk8hWwra75a5o6Rwbj5wiCUIdSnsAcB+7Mno=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    hash = "sha256-AtHRuzpKXp+WlFser0J5MR63rbO0xO4N/L3U0Q3iax8=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/symfony-cli $out/bin/symfony
  '';

  # Tests requires network access
  checkPhase = ''
    $GOPATH/bin/symfony-cli
  '';

  meta = {
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = lib.licenses.agpl3Plus;
    mainProgram = "symfony";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
