{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  version = "1.7.0";
  pname = "drone-cli";
  revision = "v${version}";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone-cli";
    rev = revision;
    hash = "sha256-PZ0M79duSctPepD5O+NdJZKhkyR21g/4P6loJtoWZiU=";
  };

  vendorHash = "sha256-JC7OR4ySDsVWmrBBTjpwZrkJlM8RJehbsvXW/VtA4VA=";

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
