{
  mkKdeDerivation,
  shared-mime-info,
<<<<<<< HEAD
  qtdeclarative,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
mkKdeDerivation {
  pname = "kpkpass";

  extraNativeBuildInputs = [ shared-mime-info ];
<<<<<<< HEAD
  extraBuildInputs = [ qtdeclarative ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
