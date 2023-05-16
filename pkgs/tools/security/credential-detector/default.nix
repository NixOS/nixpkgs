{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "credential-detector";
<<<<<<< HEAD
  version = "1.14.3";
=======
  version = "1.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ynori7";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-20ySTLpjTc1X0iJsbzbeLmWF0xYzzREGOqEWrB2X1GQ=";
  };

  vendorHash = "sha256-VWmfATUbfnI3eJbFTUp6MR1wGESuI15PHZWuon5M5rg=";

  ldflags = [ "-s" "-w" ];
=======
    sha256 = "sha256-zUQRzlp/7gZhCm5JYu9kYxcoFjDldCYKarRorOHa3E0=";
  };

  vendorSha256 = "sha256-VWmfATUbfnI3eJbFTUp6MR1wGESuI15PHZWuon5M5rg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Tool to detect potentially hard-coded credentials";
    homepage = "https://github.com/ynori7/credential-detector";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
