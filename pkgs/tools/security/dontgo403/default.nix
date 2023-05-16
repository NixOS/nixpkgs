{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dontgo403";
<<<<<<< HEAD
  version = "0.9.3";
=======
  version = "0.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "devploit";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-WGI98IUyvcPGD9IbIF1ZWa72Dnork6xE+XoVYUx1zAc=";
  };

  vendorHash = "sha256-IGnTbuaQH8A6aKyahHMd2RyFRh4WxZ3Vx/A9V3uelRg=";
=======
    hash = "sha256-Gpr2L7iSdMBqwMzdYDtdzyZYu+Uwjn1wZvw4LTr8xWI=";
  };

  vendorHash = "sha256-he/+M8NffvMLTdFQy5E2EnqLXkS/tK6eUGXTBKZSZCw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to bypass 40X response codes";
    homepage = "https://github.com/devploit/dontgo403";
    changelog = "https://github.com/devploit/dontgo403/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
