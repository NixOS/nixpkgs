{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "drone-runner-docker";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "drone-runners";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ZoQeCuT5FRhxp/ikB0gkp3QVOQ6OS7ukkz4QanWT9G0=";
  };

  vendorHash = "sha256-KcNp3VdJ201oxzF0bLXY4xWHqHNz54ZrVSI96cfhU+k=";

  meta = with lib; {
<<<<<<< HEAD
    maintainers = with maintainers; [ endocrimes emilylange ];
    license = licenses.unfreeRedistributable;
    homepage = "https://github.com/drone-runners/drone-runner-docker";
    description = "Drone pipeline runner that executes builds inside Docker containers";
    mainProgram = "drone-runner-docker";
=======
    maintainers = with maintainers; [ endocrimes indeednotjames ];
    license = licenses.unfreeRedistributable;
    homepage = "https://github.com/drone-runners/drone-runner-docker";
    description = "Drone pipeline runner that executes builds inside Docker containers";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
