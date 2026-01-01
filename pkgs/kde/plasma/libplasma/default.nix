{
  mkKdeDerivation,
  qtsvg,
  qtwayland,
  wayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "libplasma";

<<<<<<< HEAD
  patches = [
    # https://invent.kde.org/plasma/libplasma/-/merge_requests/1406
    ./rb-extracomponents.patch
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    qtsvg
    qtwayland
    wayland
  ];
}
