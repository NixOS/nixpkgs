{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, runCommand
, tree-sitter
}:

rustPlatform.buildRustPackage rec {
  pname = "patsh";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KmQVZwZC7KHlzNnL2IKQ76wHUDNUZKz/aFaY4ujvBo4=";
  };

  cargoSha256 = "sha256-vozQKBxAVELdqTnqBpgHX0Wyk18EZAtpiRsKjwz8xKE=";

  # tests fail on darwin due to rpath issues
  doCheck = !stdenv.isDarwin;

  TREE_SITTER_BASH = runCommand "tree-sitter-bash" { } ''
    mkdir $out
    ln -s ${tree-sitter.builtGrammars.tree-sitter-bash}/parser $out/libtree-sitter-bash.a
  '';

  meta = with lib; {
    description = "A command-line tool for patching shell scripts inspired by resholve";
    homepage = "https://github.com/nix-community/patsh";
    changelog = "https://github.com/nix-community/patsh/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
