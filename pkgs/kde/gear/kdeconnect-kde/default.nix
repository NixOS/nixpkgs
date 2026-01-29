{
  lib,
  stdenv,
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fixes macOS build by disabling incompatible D-Bus interfaces, plugins, and tests
    ./darwin-compatibility.patch
  ];

  # Hardcoded as a QString, which is UTF-16 so Nix can't pick it up automatically
  postFixup = ''
    mkdir -p $out/nix-support
    echo "${sshfs}" > $out/nix-support/depends
  '';

  # Exclude Linux-only dependencies on Darwin
  excludeDependencies = lib.optionals stdenv.hostPlatform.isDarwin [
    "modemmanager-qt"
    "plasma-wayland-protocols"
    "pulseaudio-qt"
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtconnectivity
    qtmultimedia
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    wayland-protocols
    libfakekey
  ];

  extraCmakeFlags = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.cmakeFeature "QtWaylandScanner_EXECUTABLE" "${qtbase}/libexec/qtwaylandscanner")
  ];

  meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;
}
