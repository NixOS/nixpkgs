{
  mkKdeDerivation,
  pkg-config,
<<<<<<< HEAD
  kauth,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  mpv,
}:
mkKdeDerivation {
  pname = "kalarm";

  extraCmakeFlags = [
    "-DENABLE_LIBVLC=0"
  ];

  extraNativeBuildInputs = [ pkg-config ];
<<<<<<< HEAD
  extraBuildInputs = [
    kauth
    mpv
  ];
=======
  extraBuildInputs = [ mpv ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
