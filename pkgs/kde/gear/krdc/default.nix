{
  mkKdeDerivation,
  pkg-config,
  shared-mime-info,
  qtwayland,
  libssh,
  libvncserver,
  freerdp,
}:
mkKdeDerivation {
  pname = "krdc";

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];

  extraBuildInputs = [
    qtwayland
    libssh
    libvncserver
    freerdp
  ];

  meta.mainProgram = "krdc";
}
