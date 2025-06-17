{
  mkKdeDerivation,
  qtdeclarative,
  qtmultimedia,
  qrencode,
  libdmtx,
}:
mkKdeDerivation {
  pname = "prison";

  propagatedNativeBuildInputs = [ qtmultimedia ];
  extraPropagatedBuildInputs = [ qtmultimedia ];

  extraBuildInputs = [
    qtdeclarative
    qrencode
    libdmtx
  ];
}
