{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "viddy";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iF5b5e3HPT3GJLRDxz9wN1U5rO9Ey51Cpw4p2zjffTI=";
  };

  vendorHash = "sha256-/lx2D2FIByRnK/097M4SQKRlmqtPTvbFo1dwbThJ5Fs=";

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.version=${version}"
  ];

  meta = with lib; {
    description = "A modern watch command";
    homepage = "https://github.com/sachaos/viddy";
    license = licenses.mit;
    maintainers = with maintainers; [ j-hui ];
    mainProgram = "viddy";
  };
}
