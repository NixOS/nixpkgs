{
  lib,
  mkKdeDerivation,
  substituteAll,
  sshfs,
  qtconnectivity,
  qtmultimedia,
  qtwayland,
  pkg-config,
  wayland,
  wayland-protocols,
  libfakekey,
}:
mkKdeDerivation {
  pname = "kdeconnect-kde";

  patches = [
    (substituteAll {
      src = ./hardcode-sshfs-path.patch;
      sshfs = lib.getExe sshfs;
    })
    # We build OpenSSH without ssh-dss support, so sshfs explodes at runtime.
    # See: https://github.com/NixOS/nixpkgs/commit/6ee4b8c8bf815567f7d0fa131576d2b8c0a18167
    # FIXME: upstream?
    ./remove-ssh-dss.patch
  ];

  # Hardcoded as a QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${sshfs}" > $out/nix-support/depends
  '';

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtconnectivity qtmultimedia qtwayland wayland wayland-protocols libfakekey];

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtwayland}/libexec/qtwaylandscanner"
  ];
}
