{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nmap-formatter";
<<<<<<< HEAD
  version = "2.1.1";
=======
  version = "2.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vdjagilev";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-i2g+l5XJkBjXMbJwpSirEKCDxO2Ric4CwF3jzue/4+o=";
  };

  vendorHash = "sha256-YAsWXbIyeC4uhzRFXX/bZs3cOvEa3k4/ZCoDisUN1Yw=";
=======
    hash = "sha256-UIGXstgQMBMept9W+HhyE30WYWleaU9bUTX5frctrS8=";
  };

  vendorSha256 = "sha256-VX/JVqCKhjBq67D7juHdgpzBgSjOHn0Pbmx9s04tinw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool that allows you to convert nmap output";
    homepage = "https://github.com/vdjagilev/nmap-formatter";
    changelog = "https://github.com/vdjagilev/nmap-formatter/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
