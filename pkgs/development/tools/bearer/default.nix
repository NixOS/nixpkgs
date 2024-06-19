{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  bearer,
}:

buildGoModule rec {
  pname = "bearer";
  version = "1.43.7";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    rev = "refs/tags/v${version}";
    hash = "sha256-n48HpPAga3/CBKAzJOg5uc+y9gNvVtmlsme/nY5dSRo=";
  };

  vendorHash = "sha256-84YJ9CXnOu0JeCzF2Ip54PRz8uJ3j+nkIwEMD++Gabg=";

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
