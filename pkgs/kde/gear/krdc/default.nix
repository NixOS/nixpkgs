{
  mkKdeDerivation,
  libssh,
  libvncserver,
  freerdp,
}:
mkKdeDerivation {
  pname = "krdc";

  extraBuildInputs = [libssh libvncserver freerdp];
}
