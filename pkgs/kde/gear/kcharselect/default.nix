{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kcharselect";
  outputs = [
    "out"
    "doc"
  ];
  meta.mainProgram = "kcharselect";
}
