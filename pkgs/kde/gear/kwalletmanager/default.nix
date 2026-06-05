{ mkKdeDerivation }:
mkKdeDerivation {
  pname = "kwalletmanager";

  outputs = [
    "out"
    "doc"
  ];

  meta.mainProgram = "kwalletmanager5";
}
