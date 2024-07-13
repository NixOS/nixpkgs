{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  bearer,
}:

buildGoModule rec {
  pname = "bearer";
  version = "1.45.0";

  src = fetchFromGitHub {
    owner = "bearer";
    repo = "bearer";
    rev = "refs/tags/v${version}";
    hash = "sha256-6q9mUv1S44shGr3ScqLNTw1AiFS2sQmAMionsEdfOOw=";
  };

  vendorHash = "sha256-q3JnxFSnMePBfwFdrj69uh65UXqeL0+QUvGjzkS2lGs=";

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
