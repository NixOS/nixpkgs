{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "task-keeper";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "linux-china";
    repo = "task-keeper";
    rev = "55bf587871de49cd9ac703e42218e970749a689a";
    hash = "sha256-P6RUENjK2UQ5/utW2umBTVnahf1xvbvLa3PMaD/2B6I=";
  };

  cargoLock = {
    # lockFile = "${src}/Cargo.lock"; # pending PR: https://github.com/linux-china/task-keeper/pull/2
    lockFile = ./Cargo.lock;
  };
  doCheck = false; # tests depend on many packages (java, node, python, sbt, ...) - which I'm not currently willing to set up 😅

  meta = with lib; {
    homepage = "https://github.com/linux-china/task-keeper";
    description = "A cli to manage tasks from different task runners or package managers";
    license = licenses.asl20;
    maintainers = with maintainers; [ tennox ];
  };
}
