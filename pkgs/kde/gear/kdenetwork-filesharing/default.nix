{
  mkKdeDerivation,
  qtdeclarative,
}:
mkKdeDerivation {
  pname = "kdenetwork-filesharing";

  patches = [./smbd-path.patch];

  extraBuildInputs = [qtdeclarative];

  # We can't actually install samba via PackageKit, so let's not confuse users any more than we have to
  extraCmakeFlags = ["-DSAMBA_INSTALL=OFF"];
}
