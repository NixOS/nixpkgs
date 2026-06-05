{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kpackage";

  outputs = [
    "out"
    "man"
  ];

  meta.mainProgram = "kpackagetool6";
}
