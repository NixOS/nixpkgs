{
  mkKdeDerivation,
  qtdeclarative,
  qtmultimedia,
  qrencode,
  libdmtx,
}:
mkKdeDerivation {
  pname = "prison";

  extraBuildInputs = [qtdeclarative qtmultimedia qrencode libdmtx];
}
