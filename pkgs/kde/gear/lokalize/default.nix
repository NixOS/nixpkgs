{
  mkKdeDerivation,
  pkg-config,
<<<<<<< HEAD
  kddockwidgets,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  hunspell,
}:
mkKdeDerivation {
  pname = "lokalize";

  extraNativeBuildInputs = [ pkg-config ];
<<<<<<< HEAD
  extraBuildInputs = [
    kddockwidgets

    hunspell
  ];
=======
  extraBuildInputs = [ hunspell ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
