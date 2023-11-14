{ buildGoModule
, fetchFromGitHub
, lib
, testers
, symfony-cli
}:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.7.2";
  vendorHash = "sha256-xC5EHP4Zb9lgvbxVkoVBxdQ4+f34zqRf4XapntZMTTc=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    hash = "sha256-2/2Hx+9MnnY4GMm/Zt6ssCTdtYgcP1gPRXe1yQMgXTE=";
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
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = symfony-cli;
    command = "symfony version --no-ansi";
  };

  meta = {
    changelog = "https://github.com/symfony-cli/symfony-cli/releases/tag/v${version}";
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = lib.licenses.agpl3Plus;
    mainProgram = "symfony";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
