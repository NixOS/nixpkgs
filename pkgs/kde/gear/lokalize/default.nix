{
  mkKdeDerivation,
  pkg-config,
  kddockwidgets,
  hunspell,
}:
mkKdeDerivation {
  pname = "lokalize";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    kddockwidgets

    hunspell
  ];
}
