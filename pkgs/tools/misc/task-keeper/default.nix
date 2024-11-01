{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "task-keeper";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "tennox"; # Using my fork because of https://github.com/linux-china/task-keeper/pull/5
    repo = "task-keeper";
    rev = "2a793dd7082259eab084f62bfd3a281f93c82a74";
    hash = "sha256-oPdg8abAM+uSzx0OhRjDlTf4GdfmT9ALqTaH8u/9PUk=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };
  doCheck = false; # tests depend on many packages (java, node, python, sbt, ...) - which I'm not currently willing to set up 😅

  meta = with lib; {
    homepage = "https://github.com/linux-china/task-keeper";
    description = "CLI to manage tasks from different task runners or package managers";
    license = licenses.asl20;
    maintainers = with maintainers; [ tennox ];
    mainProgram = "tk";
  };
}
