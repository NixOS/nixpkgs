{
  mkKdeDerivation,
  qtsvg,
  qtwayland,
  wayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "libplasma";

  patches = [
    # https://invent.kde.org/plasma/libplasma/-/merge_requests/1406
    ./rb-extracomponents.patch
  ];

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    qtsvg
    qtwayland
    wayland
  ];
}
