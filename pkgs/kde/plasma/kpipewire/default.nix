{
  mkKdeDerivation,
  qtquick3d,
  pkg-config,
  pipewire,
  ffmpeg,
  mesa,
  libva,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "kpipewire";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [qtquick3d pipewire ffmpeg mesa libva];

  patches = [
    # Fix for 489434: spectacle crash/freeze on finishing recording with PW 1.2+
    # https://bugs.kde.org/show_bug.cgi?id=489434
    (fetchpatch {
      url = "https://invent.kde.org/plasma/kpipewire/-/commit/1977da38ed25aa15347eb9027cb1fde3d66b075f.diff";
      sha256 = "sha256-qAcd1C1AWddn5i0KAq85Ae+pU7ohfdAjOR7jKaNTYSo=";
    })
  ];
}
