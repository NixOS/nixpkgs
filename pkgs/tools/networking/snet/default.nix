{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "snet";
  version = "unstable-2021-11-26";

  src = fetchFromGitHub {
    owner = "monsterxx03";
    repo = "snet";
    rev = "89089b55277ce3e21e2ed79a9d307f2ecc62c6db";
    sha256 = "sha256-lTbygQRABv+Dp4i7nDgXYqi4pwU2rtLNfpgtBgsq+7Y=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-dubmCLeD8Fwe1msfLN+5WzdbFkfTRnZDU3F49gjWTS4=";
=======
  vendorSha256 = "sha256-dubmCLeD8Fwe1msfLN+5WzdbFkfTRnZDU3F49gjWTS4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Transparent proxy works on linux desktop, MacOS, router";
    homepage = "https://github.com/monsterxx03/snet";
    license = licenses.mit;
    maintainers = with maintainers; [ azuwis ];
  };
}
