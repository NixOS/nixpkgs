{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-OJdR+8eGbcDjirupjcczztYbGKGKaRywZnqqjv0EOSU=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-bash-0.19.0" = "sha256-Po2r+wUWJwC+ODk/xotYI7PsmjC3TFSu1dU0FrrnAXQ=";
      "tree-sitter-facade-0.9.3" = "sha256-M/npshnHJkU70pP3I4WMXp3onlCSWM5mMIqXP45zcUs=";
      "tree-sitter-nickel-0.0.1" = "sha256-NLgbTl1Te/lHTGra4DdxLtqIg6yXf5lfyl37qpp8SNQ=";
      "tree-sitter-ocaml-0.20.1" = "sha256-5X2c2Deb8xNlp0LPQKFWIT3jwxKuuKdFlp9b3iA818Y=";
      "tree-sitter-query-0.1.0" = "sha256-Gv882sbL2fmR++h4/I7dFCp+g6pddRCaLyX7+loEoHU=";
      "web-tree-sitter-sys-1.3.0" = "sha256-9rKB0rt0y9TD/HLRoB9LjEP9nO4kSWR9ylbbOXo2+2M=";
    };
  };

  patches = [
    # the versions in `Cargo.toml`s are outdated
    (fetchpatch {
      name = "bump-version-to-0.2.0.patch";
      url = "https://github.com/tweag/topiary/commit/612fdb64f50ab15889a0b508bf727f159f26a112.patch";
      hash = "sha256-MHaAnYyjXdKbh/pE3bL2iAPX6bMQkK+LUGYCL5mBM44=";
    })
  ];

  cargoBuildFlags = [ "-p" "topiary-cli" ];
  cargoTestFlags = cargoBuildFlags;

  env = {
    TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/languages";
  };

  postInstall = ''
    install -Dm444 languages/* -t $out/share/languages
  '';

  meta = with lib; {
    description = "A uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    homepage = "https://github.com/tweag/topiary";
    changelog = "https://github.com/tweag/topiary/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
