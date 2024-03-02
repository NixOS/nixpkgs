{ lib
, buildGoModule
, fetchFromGitHub
, testers
, bearer
}:

buildGoModule rec {
  pname = "bearer";
  version = "1.40.1";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    rev = "refs/tags/v${version}";
    hash = "sha256-yfgbkF7ANJyyy3qYNLOg85+MJ8SdHCZkXsOhH0vzy8o=";
  };

  vendorHash = "sha256-TKdZVNt98jrIzXekfxRXfxEfEhb2doWTTGojOLOcKzU=";

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
    license = with licenses; [ elastic20 ];
    maintainers = with maintainers; [ fab ];
  };
}
