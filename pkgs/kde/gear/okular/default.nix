{
  mkKdeDerivation,
  pkg-config,
  qtspeech,
  qtsvg,
  plasma-activities,
  poppler,
  libtiff,
  libspectre,
  libzip,
  djvulibre,
  ebook_tools,
<<<<<<< HEAD
  fetchpatch,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  discount,
}:
mkKdeDerivation {
  pname = "okular";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtspeech
    qtsvg

    plasma-activities

    poppler
    libtiff
    libspectre
    libzip
    djvulibre
    ebook_tools
    discount
  ];
<<<<<<< HEAD
  patches = [
    (fetchpatch {
      name = "okular-extreme-downsample-fix.patch";
      url = "https://invent.kde.org/graphics/okular/-/commit/554b4c12aecd5c84c9d47b29de091af1afe8e346.patch";
      hash = "sha256-S338z+92nBYMP6uqvk7rP9AsIoZ0JJCVu9Wo4NVSufk=";
    })
  ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta.mainProgram = "okular";
}
