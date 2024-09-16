{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
  libssh,
  libvncserver,
  freerdp,
}:
mkKdeDerivation {
  pname = "krdc";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtwayland libssh libvncserver freerdp];

  meta.mainProgram = "krdc";
}
