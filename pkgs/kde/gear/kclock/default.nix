{
  mkKdeDerivation,
<<<<<<< HEAD
  pkg-config,
  qtsvg,
  qtmultimedia,
  wayland-protocols,
=======
  qtsvg,
  qtmultimedia,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
mkKdeDerivation {
  pname = "kclock";

<<<<<<< HEAD
  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia

    wayland-protocols
=======
  extraBuildInputs = [
    qtsvg
    qtmultimedia
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];
}
