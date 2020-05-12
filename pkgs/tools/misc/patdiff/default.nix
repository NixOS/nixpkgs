{ ocamlPackages }:

with ocamlPackages;

janePackage {
  pname = "patdiff";
  hash = "1yqvxdmkgcwgx3npgncpdqwkpdxiqr1q41wci7589s8z7xi5nwyz";
  buildInputs = [ core_extended expect_test_helpers patience_diff ocaml_pcre shell ];
  meta = {
    description = "File Diff using the Patience Diff algorithm";
  };
}
