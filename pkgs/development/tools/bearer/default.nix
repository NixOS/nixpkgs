{ lib
, buildGoModule
, fetchFromGitHub
, testers
, bearer
}:

buildGoModule rec {
  pname = "bearer";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    rev = "refs/tags/v${version}";
    hash = "sha256-ODhkIDt9x6ZfQy9TM6CKAkDI9RdtuVG7XrzaQeH0s2Q=";
  };

  vendorHash = "sha256-CUQtfAEyFrkdtoZEWRaUPh1rJV5/0HP1clcmRAAinTI=";

  subPackages = [
    "cmd/bearer"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/bearer/bearer/cmd/bearer/build.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = bearer;
      command = "bearer version";
    };
  };

  meta = with lib; {
    description = "Code security scanning tool (SAST) to discover, filter and prioritize security and privacy risks";
    homepage = "https://github.com/bearer/bearer";
    changelog = "https://github.com/Bearer/bearer/releases/tag/v${version}";
    license = with licenses; [ elastic ];
    maintainers = with maintainers; [ fab ];
  };
}
