{
  mkKdeDerivation,
  kdeclarative,
  cups,
}:
mkKdeDerivation {
  pname = "print-manager";

  # FIXME: cups-smb?
  extraBuildInputs = [
    kdeclarative
    cups
  ];
}
