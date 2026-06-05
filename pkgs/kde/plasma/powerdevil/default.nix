{
  mkKdeDerivation,
  pkg-config,
  ddcutil,
  qtwayland,
}:
mkKdeDerivation {
  pname = "powerdevil";

  outputs = [
    "out"
    "doc"
  ];

  patches = [
    # https://invent.kde.org/plasma/powerdevil/-/merge_requests/601
    ./rb-batterymonitor.patch
  ];
  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    ddcutil
    qtwayland
  ];
}
