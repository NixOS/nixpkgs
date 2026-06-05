{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kate";

  outputs = [
    "out"
    "doc"
    "man"
  ];
}
