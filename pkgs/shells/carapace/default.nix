{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  carapace,
}:

buildGoModule rec {
  pname = "carapace";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "carapace-sh";
    repo = "carapace-bin";
    rev = "v${version}";
    hash = "sha256-MGg0L+a4tYHwbJxrOQ9QotsfpOvxnL6K0QX6ayGGXpI=";
  };

  vendorHash = "sha256-kxd/bINrZxgEmgZ67KjTTfuIr9ekpd08s0/p0Sht5Ks=";

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
