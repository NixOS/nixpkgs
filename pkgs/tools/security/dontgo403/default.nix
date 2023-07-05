{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dontgo403";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "devploit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-WGI98IUyvcPGD9IbIF1ZWa72Dnork6xE+XoVYUx1zAc=";
  };

  vendorHash = "sha256-IGnTbuaQH8A6aKyahHMd2RyFRh4WxZ3Vx/A9V3uelRg=";

  meta = with lib; {
    description = "Tool to bypass 40X response codes";
    homepage = "https://github.com/devploit/dontgo403";
    changelog = "https://github.com/devploit/dontgo403/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
