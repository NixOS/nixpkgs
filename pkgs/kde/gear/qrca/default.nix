{
  mkKdeDerivation,
  pkg-config,
  qtmultimedia,
<<<<<<< HEAD
  kirigami-addons,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
mkKdeDerivation {
  pname = "qrca";

  extraNativeBuildInputs = [ pkg-config ];
<<<<<<< HEAD
  extraBuildInputs = [
    qtmultimedia
    kirigami-addons
  ];
=======
  extraBuildInputs = [ qtmultimedia ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
