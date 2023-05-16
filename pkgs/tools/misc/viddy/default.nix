{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "viddy";
<<<<<<< HEAD
  version = "0.3.7";
=======
  version = "0.3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-82q73L0641d5qNmB+WLkUmDP5OHMoj2SNFc+FhknhwU=";
  };

  vendorHash = "sha256-FMSgLI1W5keRnSYVyY0XuarMzLWvm9D1ufUYmZttfxk=";
=======
    sha256 = "sha256-AcRfKu6P7b/HsuC6DTezbYLI9rQZwjklH/bs7mKITUk=";
  };

  vendorSha256 = "sha256-QxYM4N3E/BqmeNaofLR1crwFLVaF3IigDXKlKA2Bkuw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
  };
}
