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

  vendorSha256 = "sha256-90NWpMEUlPo5+G7DnqFrZyTlAYDAFfZrsctNTaWVjX4=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://duplicacy.com";
    description = "A new generation cloud backup tool";
    platforms = platforms.linux ++ platforms.darwin;
    license = lib.licenses.unfree;
    maintainers = with maintainers; [ ffinkdevs devusb ];
  };
}
