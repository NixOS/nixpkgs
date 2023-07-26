{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-RYJaZGJijaS4a9gJmEvi4jVDN0sglUJHuy04pGdv5YE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
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

  postInstall = ''
    install -Dm444 languages/* -t $out/share/languages
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    homepage = "https://github.com/tweag/topiary";
    changelog = "https://github.com/tweag/topiary/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
