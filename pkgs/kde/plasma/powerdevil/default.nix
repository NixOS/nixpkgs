{
  mkKdeDerivation,
  pkg-config,
  ddcutil,
  qtwayland,
}:
mkKdeDerivation {
  pname = "powerdevil";

  patches = [
    # https://invent.kde.org/plasma/powerdevil/-/merge_requests/595
    ./rb-brightness.patch
    # https://invent.kde.org/plasma/powerdevil/-/merge_requests/595
    ./rb-batterymonitor.patch
  ];
  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    ddcutil
    qtwayland
  ];
}
