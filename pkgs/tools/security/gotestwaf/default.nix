{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gotestwaf,
  testers,
}:

buildGoModule rec {
  pname = "gotestwaf";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "wallarm";
    repo = "gotestwaf";
    rev = "refs/tags/v${version}";
    hash = "sha256-stGjxv9cgYxxclQpyytN6dhFm2G1Gxbf9MdyKw6gEC4=";
  };

  vendorHash = "sha256-mPqCphweDF9RQibdjTaXXfXdO8NENHVMdIPxrJEw2g4=";

  # Some tests require networking as of v0.4.0
  doCheck = false;

  ldflags = [
    "-w"
    "-s"
    "-X=github.com/wallarm/gotestwaf/internal/version.Version=v${version}"
  ];

  passthru.tests.version = testers.testVersion {
    command = "gotestwaf --version";
    package = gotestwaf;
    version = "v${version}";
  };

  meta = with lib; {
    description = "Tool for API and OWASP attack simulation";
    homepage = "https://github.com/wallarm/gotestwaf";
    changelog = "https://github.com/wallarm/gotestwaf/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gotestwaf";
  };
}
