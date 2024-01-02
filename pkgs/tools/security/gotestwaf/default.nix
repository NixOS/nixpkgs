{ lib
, buildGoModule
, fetchFromGitHub
, gotestwaf
, testers
}:

buildGoModule rec {
  pname = "gotestwaf";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "wallarm";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-fBmn+p5uVGnI4lyL12cX4S8eda79k2Y0RPQG9iZQs2Q=";
  };

  vendorHash = null;

  # Some tests require networking as of v0.4.0
  doCheck = false;

  ldflags = [
    "-X=github.com/wallarm/gotestwaf/internal/version.Version=v${version}"
  ];

  postFixup = ''
    # Rename binary
    mv $out/bin/cmd $out/bin/${pname}
  '';

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
  };
}
