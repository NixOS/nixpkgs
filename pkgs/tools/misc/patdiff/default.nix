{ ocamlPackages }:

with ocamlPackages;

janePackage {
  pname = "patdiff";
  hash = "1yslj6xxyv8rx8y5s1civ1zq8y6vvxmkszdds958zdm1p1ign54r";
  buildInputs = [ core patience_diff ocaml_pcre ];
  meta = {
    description = "File Diff using the Patience Diff algorithm";
  };
}
