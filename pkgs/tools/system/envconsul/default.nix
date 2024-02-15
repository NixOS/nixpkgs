{ lib, buildGoModule, fetchFromGitHub, testers, envconsul }:

buildGoModule rec {
  pname = "envconsul";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "envconsul";
    rev = "v${version}";
    hash = "sha256-GZU1lEAI3k5EUU/z4gHR8plECudwp+YYyPSk7E0NQtI=";
  };

  vendorHash = "sha256-ehxeupO8CrKqkqK11ig7Pj4XTh61VOE4rT2T2SsChxw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hashicorp/envconsul/version.Name=envconsul"
  ];

  passthru.tests.version = testers.testVersion {
    package = envconsul;
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/hashicorp/envconsul/";
    description = "Read and set environmental variables for processes from Consul";
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
    mainProgram = "envconsul";
  };
}
