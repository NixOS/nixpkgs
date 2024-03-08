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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "afnanenayet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rB580TlM0/HXYgPvWtm7KMtXrw6i996HyvCrNr3QmNA=";
    fetchSubmodules = false;
  };

  cargoHash = "sha256-8ajCXoB+mVhHrstVG+QkWYfXJqDk4+XPcO6yjR4TqpQ=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "dynamic-grammar-libs"
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    # completions are not yet implemented
    # so we can safely remove this without installing the completions
    rm $out/bin/diffsitter_completions

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
