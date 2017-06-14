{ ocamlPackages }:

with ocamlPackages;

janePackage {
  name = "patdiff";
  hash = "15b6nkmd2z07j4nnmkb2g6qn3daw2xmmz3lgswkj03v29ffib014";
  buildInputs = [ core_extended expect_test_helpers patience_diff ocaml_pcre ];
  meta = {
    description = "File Diff using the Patience Diff algorithm";
  };
}
