{ ocamlPackages }:

with ocamlPackages;

janePackage {
  name = "patdiff";
  hash = "04kl9h7j3pzpyic8p34b8i9vpf6qn7ixp077d8i44cpbymdqdn96";
  buildInputs = [ core_extended expect_test_helpers patience_diff ocaml_pcre ];
  meta = {
    description = "File Diff using the Patience Diff algorithm";
  };
}
