{ lib
, buildGoModule
, fetchFromGitHub
, testers
, relic
}:

buildGoModule rec {
  pname = "relic";
  version = "7.6.2";

  src = fetchFromGitHub {
    owner = "sassoftware";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-T76+Ftky1rSIqEoKE3RLsf6g2gguVJgYFflWmyEhdEk=";
  };

  vendorHash = "sha256-5mgqIw3BV88rEF3ALD3pLhm658yUUFf44hQFSw085cU=";

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
    mainProgram = "relic";
    license = licenses.asl20;
    maintainers = with maintainers; [ strager ];
  };
}
