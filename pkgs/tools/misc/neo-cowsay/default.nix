{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "neo-cowsay";
<<<<<<< HEAD
  version = "2.0.4";
=======
  version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Code-Hex";
    repo = "Neo-cowsay";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-DmIjqBTIzwkQ8aJ6xCgIwjDtczlTH5AKbPKFUGx3qQ8=";
  };

  vendorHash = "sha256-gBURmodXkod4fukw6LWEY+MBxPcf4vn/f6K78UR77n0=";

  modRoot = "./cmd";

  doCheck = false;

  subPackages = [ "cowsay" "cowthink" ];
=======
    sha256 = "sha256-VswknPs/yCUOUsXoGlGNF22i7dK8FrYzWkUWlfIPrNo=";
  };

  vendorSha256 = "sha256-kJSKDqw2NpnPjotUM6Ck6sixCJt3nVOdx800/+JBiWM=";

  doCheck = false;

  subPackages = [ "cmd/cowsay" "cmd/cowthink" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Cowsay reborn, written in Go";
    homepage = "https://github.com/Code-Hex/Neo-cowsay";
<<<<<<< HEAD
    license = with licenses; [ artistic1 /* or */ gpl3 ];
=======
    license = with licenses; [artistic1 /* or */ gpl3];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
