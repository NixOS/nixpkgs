{
  mkKdeDerivation,
  pkg-config,
  libwacom,
<<<<<<< HEAD
  xf86-input-wacom,
=======
  xf86_input_wacom,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
mkKdeDerivation {
  pname = "wacomtablet";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    libwacom
<<<<<<< HEAD
    xf86-input-wacom
=======
    xf86_input_wacom
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];
  meta.mainProgram = "kde_wacom_tabletfinder";
}
