{ lib, buildGoModule, fetchFromGitHub, testers, carapace }:

buildGoModule rec {
  pname = "carapace";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "rsteube";
    repo = "${pname}-bin";
    rev = "v${version}";
    hash = "sha256-nmih6kyVaYLVOG+EEaCUYkVRAXPXXUdPchv6JFzlU+U=";
  };

  vendorHash = "sha256-QG+50wqYYpASzFv8Y3rpuyahW/lTV8Kz+v3rDt1kAN4=";

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
