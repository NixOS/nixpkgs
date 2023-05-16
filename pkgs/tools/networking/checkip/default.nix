{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "checkip";
<<<<<<< HEAD
  version = "0.46.1";
=======
  version = "0.45.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-U0jHwKmGHpaHSiOYDeYCXiufw0JjzAmhBnINmFsqOJo=";
=======
    rev = "v${version}";
    sha256 = "sha256-GUVyeQtUNnW8yu/dhfip61jxQtgQmjBUDzsOW233laQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-9/z1mtZGqrvcvq8cWBpYN7kaPHaPqtyMwMNxuRRP4Cs=";

<<<<<<< HEAD
  ldflags = [
    "-w"
    "-s"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Requires network
  doCheck = false;

  meta = with lib; {
    description = "CLI tool that checks an IP address using various public services";
    homepage = "https://github.com/jreisinger/checkip";
<<<<<<< HEAD
    changelog = "https://github.com/jreisinger/checkip/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
