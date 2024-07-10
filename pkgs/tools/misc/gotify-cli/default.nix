{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gotify-cli";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "gotify";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-Hzdd9T8RcLxHG+vHb4KuKqW4SwcWDrVc6DZ0QUpH2Xc=";
  };

  vendorHash = "sha256-+G0LWlPiDcYmEou4gpoIU/OAjzQ3VSHftM1ViG9lhYM=";

  postInstall = ''
    mv $out/bin/cli $out/bin/gotify
  '';

  ldflags = [
    "-X main.Version=${version}" "-X main.Commit=${version}" "-X main.BuildDate=1970-01-01"
  ];

  meta = with lib; {
    license = licenses.mit;
    homepage = "https://github.com/gotify/cli";
    description = "Command line interface for pushing messages to gotify/server";
    maintainers = with maintainers; [ ];
    mainProgram = "gotify";
  };
}
