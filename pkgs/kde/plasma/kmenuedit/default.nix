{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kmenuedit";
  outptus = [
    "out"
    "doc"
  ];
  meta.mainProgram = "kmenuedit";
}
