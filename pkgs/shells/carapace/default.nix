{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  carapace,
}:

buildGoModule rec {
  pname = "carapace";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    rev = "v${version}";
    hash = "sha256-UUWZ/ZI8GTwvS8811Uzc8CjBsM/9ALxJLSFnzEE5pi4=";
  };

  vendorHash = "sha256-Fd1tbeBfbGnhOfowas2lF90TwjoRwOuk5xx9GhYEiRc=";

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
