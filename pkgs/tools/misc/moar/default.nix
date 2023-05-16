{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "moar";
<<<<<<< HEAD
  version = "1.16.1";
=======
  version = "1.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "walles";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-r1M47KYFJYhLX1HK0uPVkupghyoqdbhStgaquvC4MQI=";
=======
    sha256 = "sha256-fpUfIKDKjIHkMWzv0ZWb0mYuDDj2j7AyaiM9+LlVmPA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-aFCv6VxHD1bOLhCHXhy4ubik8Z9uvU6AeqcMqIZI2Oo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./moar.1
  '';

  ldflags = [
    "-s" "-w"
    "-X" "main.versionString=v${version}"
  ];

  meta = with lib; {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moar";
    license = licenses.bsd2WithViews;
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
