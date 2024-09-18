{
  mkKdeDerivation,
  qtdeclarative,
  qtsvg,
  libkmahjongg,
}:
mkKdeDerivation {
  pname = "kmahjongg";

  extraBuildInputs = [qtdeclarative qtsvg];

  qtWrapperArgs = ["--prefix XDG_DATA_DIRS : ${libkmahjongg}/share"];
  meta.mainProgram = "kmahjongg";
}
