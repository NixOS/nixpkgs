{
  mkKdeDerivation,
  qt5compat,
  lib,
}:
mkKdeDerivation {
  pname = "kdegraphics-mobipocket";

  extraBuildInputs = [ qt5compat ];

  meta.platforms = lib.platforms.unix;
}
