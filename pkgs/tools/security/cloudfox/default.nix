{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloudfox";
<<<<<<< HEAD
  version = "1.12.2";
=======
  version = "1.10.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "BishopFox";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-r9YIJ+PRUA1stKTL39+/T+m1WMkocpjfzG8Y9knnFU4=";
  };

  vendorHash = "sha256-nSisRurpareGI4EHENayMhsYOKL1hE1wVw2Ueiqii4U=";
=======
    hash = "sha256-XLn2GwoVNPoGTgXZx/q9dEmWigKB1BNylzxO9dBT3Zg=";
  };

  vendorHash = "sha256-v8rEsp2mDgfjCO2VvWNIxex8F350MDnZ40bR4szv+3o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Some tests are failing because of wrong filename/path
  doCheck = false;

  meta = with lib; {
    description = "Tool for situational awareness of cloud penetration tests";
    homepage = "https://github.com/BishopFox/cloudfox";
    changelog = "https://github.com/BishopFox/cloudfox/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
