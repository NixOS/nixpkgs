{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  carapace,
}:

buildGoModule rec {
  pname = "carapace";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    tag = "v${version}";
    hash = "sha256-ewZ06HPAS7UXmnRlrOaHegVrfYxwko/jyHqtQV/0JwY=";
  };

  vendorHash = "sha256-+jOZ7EhMQZHvu4XToM7L1w2YCKCTOHKzZCOBsulLsH8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    GOOS= GOARCH= go generate ./...
  '';

  passthru.tests.version = testers.testVersion { package = carapace; };

  meta = with lib; {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://carapace.sh/";
    maintainers = with maintainers; [ mimame ];
    license = licenses.mit;
    mainProgram = "carapace";
  };
}
