{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "lmp";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "0xInfection";
    repo = "LogMePwn";
    rev = "v${version}";
    sha256 = "sha256-VL/Hp7YaXNcV9JPb3kgRHcdhJJ5p3KHUf3hHbT3gKVk=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-3NTaJ/Y3Tc6UGLfYTKjZxAAI43GJyZQ5wQVYbnXHSYc=";
=======
  vendorSha256 = "sha256-3NTaJ/Y3Tc6UGLfYTKjZxAAI43GJyZQ5wQVYbnXHSYc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Scanning and validation toolkit for the Log4J vulnerability";
    homepage = "https://github.com/0xInfection/LogMePwn";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
