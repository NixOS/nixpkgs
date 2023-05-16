{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aws-lambda-runtime-interface-emulator";
<<<<<<< HEAD
  version = "1.12";
=======
  version = "1.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-lambda-runtime-interface-emulator";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-4uUyrPLDmmPv2Z6M3czwKe8BXe5BWJbfgf5FC/74pog=";
  };

  vendorHash = "sha256-0b4yjyPnE7xPmW5N1Zu/tH50gHj46TnHkycNFDzIjy8=";
=======
    sha256 = "sha256-N5RTMShukJCiM0NYzFsANUDww8iLT/p7Li0hAXerjAM=";
  };

  vendorHash = "sha256-AZDbBFF7X247AYOVvJ5vuzuVqHqH6MbUylF5lRamzhU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # disabled because I lack the skill
  doCheck = false;

  meta = with lib; {
    description = "To locally test their Lambda function packaged as a container image.";
    homepage = "https://github.com/aws/aws-lambda-runtime-interface-emulator";
    license = licenses.asl20;
    maintainers = with maintainers; [ teto ];
  };
}
