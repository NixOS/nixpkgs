{
  lib,
  fetchFromGitHub,
  buildGoModule,
  enableUnfree ? true,
}:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.27.2";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-SotlKv5gAeSTuhk60Y5Srgaogr7Fm7JO1CuGJ5eE0pg=";
  };

  vendorHash = "sha256-ELJ/+LOwsQUGl0unsqDOX9mNxSUQFzeuOlqay24tZ4k=";

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
