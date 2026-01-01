{
  mkKdeDerivation,
  qtdeclarative,
<<<<<<< HEAD
  qtlocation,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pkg-config,
}:
mkKdeDerivation {
  pname = "kpublictransport";

  extraNativeBuildInputs = [ pkg-config ];
<<<<<<< HEAD
  extraBuildInputs = [
    qtdeclarative
    qtlocation
  ];
=======
  extraBuildInputs = [ qtdeclarative ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
