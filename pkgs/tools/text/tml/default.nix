{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tml";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "tml";
    rev = "v${version}";
    hash = "sha256-y9iv6s+ShKLxd+SOBQxwvPwuEL1kepJL6ukA4aoV9Z8=";
  };

  vendorHash = "sha256-CHZS1SpPko8u3tZAYbf+Di882W55X9Q/zd4SmFCRgKM=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "A tiny markup language for terminal output";
    homepage = "https://github.com/liamg/tml";
    changelog = "https://github.com/liamg/tml/releases/tag/v${version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ figsoda ];
  };
}
