{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-containerregistry";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3mvGHAPKDUmrQkBKwlxnF6PG0ZpZDqlM9SMkCyC5ytE=";
  };
  vendorSha256 = null;

  subPackages = [ "cmd/crane" "cmd/gcrane" ];

  ldflags =
    let t = "github.com/google/go-containerregistry"; in
    [ "-s" "-w" "-X ${t}/cmd/crane/cmd.Version=v${version}" "-X ${t}/pkg/v1/remote/transport.Version=${version}" ];

  # NOTE: no tests
  doCheck = false;

  meta = with lib; {
    description = "Tools for interacting with remote images and registries including crane and gcrane";
    homepage = "https://github.com/google/go-containerregistry";
    license = licenses.apsl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
