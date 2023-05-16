{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "duplicacy";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "gilbertchen";
    repo = "duplicacy";
    rev = "v${version}";
    sha256 = "sha256-PYUfECxtUG2WuLmYLtE3Ugcr8GeQMQwQa4uFzcl1RoY=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-90NWpMEUlPo5+G7DnqFrZyTlAYDAFfZrsctNTaWVjX4=";
=======
  vendorSha256 = "sha256-90NWpMEUlPo5+G7DnqFrZyTlAYDAFfZrsctNTaWVjX4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  meta = with lib; {
    homepage = "https://duplicacy.com";
    description = "A new generation cloud backup tool";
    platforms = platforms.linux ++ platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ ffinkdevs devusb ];
  };
}
