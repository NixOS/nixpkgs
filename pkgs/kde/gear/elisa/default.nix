{
  lib,
  mkKdeDerivation,
  qtmultimedia,
  libvlc,

  withVLC ? true,
}:
mkKdeDerivation {
  pname = "elisa";

  extraBuildInputs = [ qtmultimedia ] ++ lib.optional withVLC libvlc;
  meta.mainProgram = "elisa";
}
