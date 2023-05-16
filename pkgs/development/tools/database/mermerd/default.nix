<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, testers
, mermerd
=======
{ buildGoModule
, fetchFromGitHub
, lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "mermerd";
<<<<<<< HEAD
  version = "0.9.0";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "KarnerTh";
    repo = "mermerd";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-oYX1473bfZHwCscIpZSDfkKgIsGMcmkFGfWI400Maao=";
=======
    hash = "sha256-nlertvmuP9Fiuc4uVrgKzfxjOY/sE9udKZLe51t0GEY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-RSCpkQymvUvY2bOkjhsyKnDa3vezUjC33Nwv0+O4OOQ=";

<<<<<<< HEAD
  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
  ];

  # the tests expect a database to be running
  doCheck = false;

  passthru.tests = {
    version = testers.testVersion {
      package = mermerd;
      command = "mermerd version";
    };
  };

  meta = with lib; {
    description = "Create Mermaid-Js ERD diagrams from existing tables";
    homepage = "https://github.com/KarnerTh/mermerd";
    changelog = "https://github.com/KarnerTh/mermerd/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ austin-artificial ];
  };
=======
  # the tests expect a database to be running
  doCheck = false;

  meta = with lib; {
    description = "Create Mermaid-Js ERD diagrams from existing tables";
    homepage = "https://github.com/KarnerTh/mermerd";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ austin-artificial ];
    changelog = "https://github.com/KarnerTh/mermerd/releases/tag/v${version}";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
