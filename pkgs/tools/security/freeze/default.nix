{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "freeze";
<<<<<<< HEAD
  version = "1.3";
=======
  version = "1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "optiv";
    repo = "Freeze";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-BE5MvCU+NfEccauOdWNty/FwMiWwLttPh7eE9+UzEMY=";
=======
    hash = "sha256-ySwd7xs9JdJuBvqKC4jI/qA6qVHbYPPUEG7k6joSkRk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = "sha256-R8kdFweMhAUjJ8zJ7HdF5+/vllbNmARdhU4hOw4etZo=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    mv $out/bin/Freeze $out/bin/freeze
  '';

  meta = with lib; {
    description = "Payload toolkit for bypassing EDRs";
    homepage = "https://github.com/optiv/Freeze";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
