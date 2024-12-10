{
  mkKdeDerivation,
  qt5compat,
}:
mkKdeDerivation {
  pname = "libkomparediff2";

  extraBuildInputs = [ qt5compat ];

  meta.broken = true; # Qt5
}
