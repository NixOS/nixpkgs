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
  fetchpatch,
  discount,
  kirigami-addons,
}:
mkKdeDerivation {
  pname = "okular";

  extraOutputs = [ "mobile" ];

  extraCmakeFlags = [ "-DOKULAR_UI=both" ];

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

    # Needed at runtime by the mobile UI
    kirigami-addons
  ];

  postInstall = ''
    moveToOutput bin/okularkirigami $mobile
    moveToOutput share/applications/org.kde.okular.kirigami.desktop $mobile
    moveToOutput 'share/applications/org.kde.mobile.okular_*.desktop' $mobile
    moveToOutput share/metainfo/org.kde.okular.kirigami.appdata.xml $mobile

    # The desktop files of the mobile UI use the same icon, so make it
    # available when only the mobile output is installed.
    ln -s $out/share/icons $mobile/share/icons
  '';

  meta.mainProgram = "okular";
}
