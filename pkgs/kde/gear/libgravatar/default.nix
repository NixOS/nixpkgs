{ mkKdeDerivation, pimcommon }:
mkKdeDerivation {
  pname = "libgravatar";

  extraBuildInputs = [ pimcommon ];
}
