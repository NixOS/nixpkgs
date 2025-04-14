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

    # Fix build with Qt 6.9
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/network/kdeconnect-kde/-/commit/120a089ed8a45176289b8f1addf044817b13aa7b.patch";
      hash = "sha256-ifos4wMFimhtksqMhhHPfHrEV5+PSXLdapgqGwQj/Hc=";
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
