{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "symfony-cli";
  version = "5.4.21";
  vendorHash = "sha256-P5KEliTqj9kGYffhl014QK6qPY9gLG+bViOz4dtsQwA=";

  src = fetchFromGitHub {
    owner = "symfony-cli";
    repo = "symfony-cli";
    rev = "v${version}";
    sha256 = "sha256-lNEd5mj5K8MhlLkrRiFnEqVLnS+4mx7FNAtYuF5jdC0=";
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

  meta = with lib; {
    description = "Symfony CLI";
    homepage = "https://github.com/symfony-cli/symfony-cli";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ drupol ];
  };
}
