{ lib
, buildGoModule
, fetchFromGitHub
, testers
, bearer
}:

buildGoModule rec {
  pname = "bearer";
  version = "1.41.0";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    rev = "refs/tags/v${version}";
    hash = "sha256-RwoUyEIwKGDRqkETGEo6x1U14lqBogDzsoOHQKt8lHc=";
  };

  vendorHash = "sha256-KCsCUVO2WsKJKU/aiXgeyS01341Xf9yQnKvQ7hAkYbQ=";

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
