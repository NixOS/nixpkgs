{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dontgo403";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "devploit";
    repo = "dontgo403";
    rev = "refs/tags/${version}";
    hash = "sha256-qA1i8l2oBQQ5IF8ho3K2k+TAndUTFGwb2NfhyFqfKzU=";
  };

  vendorHash = "sha256-IGnTbuaQH8A6aKyahHMd2RyFRh4WxZ3Vx/A9V3uelRg=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = with lib; {
    description = "Tool to bypass 40X response codes";
    mainProgram = "nomore403";
    homepage = "https://github.com/devploit/dontgo403";
    changelog = "https://github.com/devploit/dontgo403/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
