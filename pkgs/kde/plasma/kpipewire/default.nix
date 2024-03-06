{
  mkKdeDerivation,
  fetchpatch,
  qtquick3d,
  pkg-config,
  pipewire,
  ffmpeg,
  mesa,
  libva,
}:
mkKdeDerivation {
  pname = "kpipewire";

  # FIXME: backport to fix build, remove for 6.0.2
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kpipewire/-/commit/df052bfa3c66d24109f40f18266ee057d1838b9b.patch";
      hash = "sha256-69ftUUz5cvG/CmCw3hHFeU8XKhZPJjnx1raJCCay38g=";
    })
  ];

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtquick3d pipewire ffmpeg mesa libva];
}
