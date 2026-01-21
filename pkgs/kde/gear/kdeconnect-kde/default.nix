{
  lib,
  mkKdeDerivation,
  replaceVars,
  sshfs,
  qtbase,
  qtconnectivity,
  qtmultimedia,
  pkg-config,
  wayland,
  wayland-protocols,
  libfakekey,
}:
mkKdeDerivation {
  pname = "kdeconnect-kde";

  patches = [
    (replaceVars ./hardcode-sshfs-path.patch {
      sshfs = lib.getExe sshfs;
    })
  ];

  # Hardcoded as a QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${sshfs}" > $out/nix-support/depends
  '';

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtconnectivity
    qtmultimedia
    wayland
    wayland-protocols
    libfakekey
  ];

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtbase}/libexec/qtwaylandscanner"
  ];
}
