{
  lib,
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
  fetchpatch,
  discount,
  kirigami-addons,
  mobile ? false,
}:
mkKdeDerivation {
  pname = "okular";

  extraCmakeFlags = lib.optionals mobile [ "-DOKULAR_UI=mobile" ];

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
  ]
  ++ lib.optionals mobile [ kirigami-addons ];

  meta.mainProgram = if mobile then "okularkirigami" else "okular";
}
