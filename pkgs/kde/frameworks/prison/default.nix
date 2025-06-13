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

  extraBuildInputs = [
    qtdeclarative
    qtmultimedia
    qrencode
    libdmtx
  ];
}
