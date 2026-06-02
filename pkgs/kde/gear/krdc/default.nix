{
  mkKdeDerivation,
  pkg-config,
  shared-mime-info,
  qtwayland,
  libssh,
  libvncserver,
  freerdp,
  fuse3,
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
    fuse3
  ];

  meta.mainProgram = "krdc";
}
