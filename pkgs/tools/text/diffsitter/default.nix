{ lib
, fetchFromGitHub
, linkFarm
, makeWrapper
, rustPlatform
, tree-sitter
}:

let
  # based on https://github.com/NixOS/nixpkgs/blob/aa07b78b9606daf1145a37f6299c6066939df075/pkgs/development/tools/parsing/tree-sitter/default.nix#L85-L104
  withPlugins = grammarFn:
    let
      grammars = grammarFn tree-sitter.builtGrammars;
    in
    linkFarm "grammars"
      (map
        (drv:
          let
            name = lib.strings.getName drv;
          in
          {
            name =
              "lib" +
              (lib.strings.removeSuffix "-grammar" name)
              + ".so";
            path = "${drv}/parser";
          }
        )
        grammars);

  libPath = withPlugins (_: tree-sitter.allGrammars);
in
rustPlatform.buildRustPackage rec {
  pname = "diffsitter";
<<<<<<< HEAD
  version = "0.8.1";
=======
  version = "0.7.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "afnanenayet";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-8nKZ8zcZSSF7Qd36kA9IQjio+TIhlQWRgMqKrsdInj4=";
    fetchSubmodules = false;
  };

  cargoHash = "sha256-LEBAMb9tROpjrWEfucw+2ZaytnoyJE477IH3MyeUGEA=";
=======
    sha256 = "sha256-AJjgn+qFfy6/gjb8tQOJDmevZy1ZfpF0nTxAgunSabE=";
    fetchSubmodules = false;
  };

  cargoSha256 = "sha256-U/XvllkzEVt4TpDPA5gSRKpIIQagATGdHh7YPFOo4CY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "dynamic-grammar-libs"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
<<<<<<< HEAD
    # completions are not yet implemented
    # so we can safely remove this without installing the completions
    rm $out/bin/diffsitter_completions

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapProgram "$out/bin/diffsitter" \
      --prefix LD_LIBRARY_PATH : "${libPath}"
  '';

  doCheck = false;
  # failures:
  #     tests::diff_hunks_snapshot::_medium_cpp_cpp_false_expects
  #     tests::diff_hunks_snapshot::_medium_cpp_cpp_true_expects
  #     tests::diff_hunks_snapshot::_medium_rust_rs_false_expects
  #     tests::diff_hunks_snapshot::_medium_rust_rs_true_expects
  #     tests::diff_hunks_snapshot::_short_python_py_true_expects
  #     tests::diff_hunks_snapshot::_short_rust_rs_true_expects

  meta = with lib; {
    homepage = "https://github.com/afnanenayet/diffsitter";
    description = "A tree-sitter based AST difftool to get meaningful semantic diffs";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
