{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  version = "1.8.0";
  pname = "drone-cli";
  revision = "v${version}";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone-cli";
    rev = revision;
    hash = "sha256-moxsGlm7Q9E0q9SZ2gZotn3tRbnbtwhDc9UNCCSb3pY=";
  };

  vendorHash = "sha256-rKZq2vIXvw4bZ6FXPqOip9dLiV5rSb1fWDJe3oxOBjw=";

  # patch taken from https://patch-diff.githubusercontent.com/raw/harness/drone-cli/pull/179.patch
  # but with go.mod changes removed due to conflict
  patches = [ ./0001-use-builtin-go-syscerts.patch ];

  ldflags = [
    "-X main.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    mainProgram = "drone";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
