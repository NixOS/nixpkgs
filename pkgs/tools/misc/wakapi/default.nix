{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wakapi";
<<<<<<< HEAD
  version = "2.8.1";
=======
  version = "2.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "muety";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-5EUXhKv4cLDaHr6Q2mel3YbVPAYRJd1JtHyWn7kQy8Y=";
  };

  vendorHash = "sha256-rwQeIHJAtnRm5nPQCvgoBabVeyLZyrY3yglCW9+NGwM=";
=======
    sha256 = "sha256-1EMSrHx6Tx58voz5veyNZg1gnubuGyg2K4dg2QdzmMw=";
  };

  vendorHash = "sha256-0wHXULDKyXYBTGxfSQXT/5NidPtSnx7ujb8vyczmE38=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Not a go module required by the project, contains development utilities
  excludedPackages = [ "scripts" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://wakapi.dev/";
    changelog = "https://github.com/muety/wakapi/releases/tag/${version}";
    description = "A minimalist self-hosted WakaTime-compatible backend for coding statistics";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ t4ccer ];
  };
}
