{
  lib,
  mkKdeDerivation,
  replaceVars,
  sshfs,
  qtconnectivity,
  qtmultimedia,
  qtwayland,
  pkg-config,
  wayland,
  wayland-protocols,
  libfakekey,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "kdeconnect-kde";

  patches = [
    (replaceVars ./hardcode-sshfs-path.patch {
      sshfs = lib.getExe sshfs;
    })
    # Fix CVE-2025-66270 (https://kde.org/info/security/advisory-20251128-1.txt)
    (fetchpatch {
      name = "CVE-2025-66270.patch";
      url = "https://invent.kde.org/network/kdeconnect-kde/-/commit/4e53bcdd5d4c28bd9fefd114b807ce35d7b3373e.patch";
      hash = "sha256-qtcXNJ5qL4xtZQ70R/wWVCzFGzXNltr6XTgs0fpkTi4=";
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
    qtwayland
    wayland
    wayland-protocols
    libfakekey
  ];

  extraCmakeFlags = [
    "-DQtWaylandScanner_EXECUTABLE=${qtwayland}/libexec/qtwaylandscanner"
  ];
}
