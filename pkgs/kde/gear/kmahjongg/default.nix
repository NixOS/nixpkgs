{
  mkKdeDerivation,
  qtdeclarative,
  qtsvg,
  libkmahjongg,
}:
mkKdeDerivation {
  pname = "kmahjongg";

  __structuredAttrs = true;

  extraBuildInputs = [
    qtdeclarative
    qtsvg
  ];

  qtWrapperArgs = [
    "--prefix"
    "XDG_DATA_DIRS"
    ":"
    "${libkmahjongg}/share"
  ];

  meta.mainProgram = "kmahjongg";
}
