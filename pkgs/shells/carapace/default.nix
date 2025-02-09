{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  carapace,
}:

buildGoModule rec {
  pname = "carapace";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    rev = "v${version}";
    hash = "sha256-4tsqzXQwLTJ3icoCFJAmUWEXvv/RwzBnOXJd4vXOE7s=";
  };

  vendorHash = "sha256-8EuPHhTNK+7OnjYKAdkSmIS/iZR2AYrDw4nfY5ixYIo=";

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
