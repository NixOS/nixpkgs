{ ocamlPackages }:

with ocamlPackages;

janePackage {
  pname = "patdiff";
  hash = "0623a7n5r659rkxbp96g361mvxkcgc6x9lcbkm3glnppplk5kxr9";
  propagatedBuildInputs = [ core_unix patience_diff ocaml_pcre ];
  meta = {
    description = "File Diff using the Patience Diff algorithm";
  };
}
