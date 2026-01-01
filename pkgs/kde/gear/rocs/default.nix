{
  mkKdeDerivation,
  boost,
}:
mkKdeDerivation {
  pname = "rocs";

  extraBuildInputs = [ boost ];
<<<<<<< HEAD
=======
  # FIXME(qt5)
  meta.broken = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
