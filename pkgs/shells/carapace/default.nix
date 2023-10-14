{ lib, buildGoModule, fetchFromGitHub, testers, carapace }:

buildGoModule rec {
  pname = "carapace";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    hash = "sha256-UcJbWOYkNUJEilJL/LG5o+I1ugqEOEGfs+uvKUMnTMU=";
  };

  vendorHash = "sha256-PN8ARsJQqRj333ervoy24PZoWkrCIYiGxOovzEhPNZQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "./cmd/carapace" ];

  tags = [ "release" ];

  preBuild = ''
    go generate ./...
  '';

  passthru.tests.version = testers.testVersion { package = carapace; };

  meta = with lib; {
    description = "Multi-shell multi-command argument completer";
    homepage = "https://rsteube.github.io/carapace-bin/";
    maintainers = with maintainers; [ star-szr ];
    license = licenses.mit;
    mainProgram = "carapace";
  };
}
