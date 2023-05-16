{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "go-cqhttp";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Mrs4s";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/nmPiB2BHltguAJFHCvtS3oh/BttEH75GhgSa25cI3s=";
  };

  vendorHash = "sha256-Oqig/qtdGFO2/t7vvkApqdNhjNnYzEavNpyneAMa10k=";
=======
    sha256 = "sha256-Vc/k4mb1JramT2l+zu9zZQa65gP5XvgqUEQgle1vX8w=";
  };

  vendorSha256 = "sha256-tAvo96hIWxkt3rrrPH5fDKwfwuc76Ze0r55R/ZssU4s=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "The Golang implementation of OneBot based on Mirai and MiraiGo";
    homepage = "https://github.com/Mrs4s/go-cqhttp";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ Anillc ];
  };
}
