{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.5.9";
  vendorHash = "sha256-eeVi/O4p7bF4CPqJBCpLfx1Yc5vZZ3b8RV5ERcIL8H4=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    hash = "sha256-dQ7ImNSnWD2u9cY9VEBlum45YqlhHgczAkD70QJFr68=";
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
