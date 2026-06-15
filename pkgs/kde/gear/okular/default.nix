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
  discount,
}:
mkKdeDerivation {
  pname = "okular";

  outputs = [
    "out"
    "doc"
    "man"
  ];

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

  meta.mainProgram = "okular";
}
