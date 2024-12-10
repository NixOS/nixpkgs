{
  lib,
  fetchFromGitHub,
  buildGoModule,
  enableUnfree ? true,
}:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    rev = "v${version}";
    sha256 = "sha256-IiSsw0bZDAVuOrm7JBTT14Cf7I/koeS2Yw6vWYBG7kA=";
  };

  vendorHash = "sha256-n4KbKkqAnHDIsXs8A/FE+rCkSKQKr5fv7npJ/X6t0mk=";

  tags = lib.optionals (!enableUnfree) [
    "oss"
    "nolimit"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Continuous Integration platform built on container technology";
    mainProgram = "drone-server";
    homepage = "https://github.com/harness/drone";
    maintainers = with maintainers; [
      vdemeester
      techknowlogick
    ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
  };
}
