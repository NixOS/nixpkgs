{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "task-keeper";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "tennox"; # Using my fork because of https://github.com/linux-china/task-keeper/pull/5
    repo = "task-keeper";
    rev = "4e39d65d01c44b44ae9876d8a3cb37066ce9f3f7";
    hash = "sha256-l/sqYuFrSDJN4Y9NN2fpkEI7AWctezLRi/pNAkPmHRk=";
  };

  cargoLock = {
    lockFile = "${./.}/Cargo.lock";
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
