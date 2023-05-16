<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.2.3";
=======
{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-RYJaZGJijaS4a9gJmEvi4jVDN0sglUJHuy04pGdv5YE=";
=======
    sha256 = "sha256-Gm6AzzVLUXZi2jzJ1b/c4yjIvRRA2e5mC2CMVyly2X8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "tree-sitter-bash-0.19.0" = "sha256-Po2r+wUWJwC+ODk/xotYI7PsmjC3TFSu1dU0FrrnAXQ=";
      "tree-sitter-facade-0.9.3" = "sha256-M/npshnHJkU70pP3I4WMXp3onlCSWM5mMIqXP45zcUs=";
      "tree-sitter-nickel-0.0.1" = "sha256-aYsEx1Y5oDEqSPCUbf1G3J5Y45ULT9OkD+fn6stzrOU=";
      "tree-sitter-ocaml-0.20.1" = "sha256-5X2c2Deb8xNlp0LPQKFWIT3jwxKuuKdFlp9b3iA818Y=";
      "tree-sitter-query-0.1.0" = "sha256-Gv882sbL2fmR++h4/I7dFCp+g6pddRCaLyX7+loEoHU=";
      "web-tree-sitter-sys-1.3.0" = "sha256-9rKB0rt0y9TD/HLRoB9LjEP9nO4kSWR9ylbbOXo2+2M=";
    };
  };

  cargoBuildFlags = [ "-p" "topiary-cli" ];
  cargoTestFlags = cargoBuildFlags;

  env = {
    TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/languages";
  };

  # Cargo.lock is outdated
  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

=======
      "tree-sitter-bash-0.19.0" = "sha256-5gBH0tBnNevAdBwlsLQAI9JOyz2lDY7Gb54HVCD4+Zs=";
      "tree-sitter-nickel-0.0.1" = "sha256-D/RRwXsWyHMxoU7Z8VVJ6jn7zUFKaKusLT/ofON7sOE=";
      "tree-sitter-ocaml-0.20.1" = "sha256-5X2c2Deb8xNlp0LPQKFWIT3jwxKuuKdFlp9b3iA818Y=";
      "tree-sitter-query-0.0.1" = "sha256-dWWof8rYFTto3A4BfbKTKcNieRbwFdF6xDXW9tQvAqQ=";
    };
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postInstall = ''
    install -Dm444 languages/* -t $out/share/languages
  '';

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };
=======
  TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/languages";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    homepage = "https://github.com/tweag/topiary";
<<<<<<< HEAD
    changelog = "https://github.com/tweag/topiary/blob/${src.rev}/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
