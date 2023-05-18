{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "topiary";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tweag";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Gm6AzzVLUXZi2jzJ1b/c4yjIvRRA2e5mC2CMVyly2X8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tree-sitter-bash-0.19.0" = "sha256-5gBH0tBnNevAdBwlsLQAI9JOyz2lDY7Gb54HVCD4+Zs=";
      "tree-sitter-nickel-0.0.1" = "sha256-D/RRwXsWyHMxoU7Z8VVJ6jn7zUFKaKusLT/ofON7sOE=";
      "tree-sitter-ocaml-0.20.1" = "sha256-5X2c2Deb8xNlp0LPQKFWIT3jwxKuuKdFlp9b3iA818Y=";
      "tree-sitter-query-0.0.1" = "sha256-dWWof8rYFTto3A4BfbKTKcNieRbwFdF6xDXW9tQvAqQ=";
    };
  };

  postInstall = ''
    install -Dm444 languages/* -t $out/share/languages
  '';

  TOPIARY_LANGUAGE_DIR = "${placeholder "out"}/share/languages";

  meta = with lib; {
    description = "A uniform formatter for simple languages, as part of the Tree-sitter ecosystem";
    homepage = "https://github.com/tweag/topiary";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
