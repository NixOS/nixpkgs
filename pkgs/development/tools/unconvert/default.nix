{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "unconvert";
  version = "unstable-2022-09-18";

  src = fetchFromGitHub {
    owner = "mdempsky";
    repo = "unconvert";
    rev = "3f84926d692329767c21c2aef3dfb7889c956832";
    sha256 = "sha256-vcRHriFCT5b8SKjtRSg+kZDcCAKySC1cKVq+FMZb+9M=";
  };

  vendorHash = "sha256-p77mLvGtohmC8J+bqqkM5kqc1pMPcFx7GhXOZ4q4jeM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Remove unnecessary type conversions from Go source";
    mainProgram = "unconvert";
    homepage = "https://github.com/mdempsky/unconvert";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kalbasit ];
  };
}
