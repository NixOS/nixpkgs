{
  lib,
  fetchFromGitHub,
  buildGoModule,
  enableUnfree ? true,
}:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-b52UjilVc5BNATlzhxBmFohd9kK3OJQOKJWy+VSAlEE=";
  };

  vendorHash = "sha256-6a4Xdp8lcPq+GPewQmEPzr9hXjSrqHR7kqw7pqHzjXE=";

  tags = lib.optionals (!enableUnfree) [
    "oss"
    "nolimit"
  ];

  doCheck = false;

  meta = {
    description = "Continuous Integration platform built on container technology";
    mainProgram = "drone-server";
    homepage = "https://github.com/harness/drone";
    maintainers = with lib.maintainers; [
      vdemeester
      techknowlogick
    ];
    license = with lib.licenses; if enableUnfree then unfreeRedistributable else asl20;
  };
}
