{ lib
, buildGoModule
, fetchFromGitHub
, testers
, relic
}:

buildGoModule rec {
  pname = "relic";
  version = "7.5.9";

  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-x+F/sXZAnGbzMCXKY05VSYM0o0ujf/aWUP/nrUo+FSs=";
  };

  vendorHash = "sha256-EZohpGzMDYKUbjSOIfoUbbsABNDOddrTt52pv+VQLdI=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = relic;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/sassoftware/relic";
    description = "A service and a tool for adding digital signatures to operating system packages for Linux and Windows";
    license = licenses.asl20;
    maintainers = with maintainers; [ strager ];
  };
}
