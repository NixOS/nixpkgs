{ ocamlPackages }:

with ocamlPackages;

janePackage {
  pname = "patdiff";
  hash = "02cdn5j5brbp4n2rpxprzxfakjbl7n2llixg7m632bih3ppmfcq1";
  buildInputs = [ core_extended expect_test_helpers patience_diff ocaml_pcre ];
  meta = {
    description = "File Diff using the Patience Diff algorithm";
  };
}
