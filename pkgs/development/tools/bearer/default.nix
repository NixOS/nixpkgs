{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  bearer,
}:

buildGoModule rec {
  pname = "bearer";
  version = "1.46.1";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    rev = "refs/tags/v${version}";
    hash = "sha256-zMQvD6ats1zJ/hK/aZh0LKWdSRqcR0BrAVcD4KnRwMQ=";
  };

  vendorHash = "sha256-1wxy/NXZCntVf8Po3Rn+pueadcveE0v3Jc0d4eYkY6s=";

  subPackages = [ "cmd/bearer" ];

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
