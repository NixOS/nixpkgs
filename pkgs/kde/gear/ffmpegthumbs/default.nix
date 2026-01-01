{
  mkKdeDerivation,
<<<<<<< HEAD
  pkg-config,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ffmpeg,
}:
mkKdeDerivation {
  pname = "ffmpegthumbs";

<<<<<<< HEAD
  extraNativeBuildInputs = [ pkg-config ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  extraBuildInputs = [ ffmpeg ];
}
