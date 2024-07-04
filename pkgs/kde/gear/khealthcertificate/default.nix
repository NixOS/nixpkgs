{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "khealthcertificate";

  extraNativeBuildInputs = [qtdeclarative];
}
