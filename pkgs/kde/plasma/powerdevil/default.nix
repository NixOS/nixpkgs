{
  mkKdeDerivation,
  pkg-config,
  ddcutil,
  qtwayland,
}:
mkKdeDerivation {
  pname = "powerdevil";

<<<<<<< HEAD
  patches = [
    # https://invent.kde.org/plasma/powerdevil/-/merge_requests/595
    ./rb-brightness.patch
  ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    ddcutil
    qtwayland
  ];
}
