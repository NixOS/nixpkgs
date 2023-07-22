{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.5.7";
  vendorHash = "sha256-OXV/hTSHJvYfe2SiFamkedC01J/DOgd8I60yIpQToos=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    hash = "sha256-LC6QQIVHllBRu8B6XfV8SuTB3O+FmqYr+LQnVmLj2nU=";
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
