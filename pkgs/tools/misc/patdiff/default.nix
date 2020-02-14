{ ocamlPackages }:

with ocamlPackages;

janePackage {
  pname = "patdiff";
  hash = "04krzn6rj2r81z55pms5ayk6bxhlxrm006cbhy0m6rc69a0h00lh";
  buildInputs = [ core_extended expect_test_helpers patience_diff ocaml_pcre shell ];
  meta = {
    description = "File Diff using the Patience Diff algorithm";
  };
}
