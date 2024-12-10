{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  carapace,
}:

buildGoModule rec {
  pname = "carapace";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    rev = "v${version}";
    hash = "sha256-ryFnccCSgQ0qEf3oRPmIO98fx2BlkK2dEFvNk2m9qSo=";
  };

  vendorHash = "sha256-biJN+WjNK/Fjjd3+ihZcFCu75fup3g9R6lIa6qHco5I=";

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
