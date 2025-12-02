{
  mkKdeDerivation,
  lib,
  fetchpatch,
  boost,
  eigen,
  gsl,
  imath,
  libetonyek,
  libgit2,
  libodfgen,
  librevenge,
  libvisio,
  libwpd,
  libwpg,
  libwps,
  okular,
  perl,
  pkg-config,
  poppler,
  qtkeychain,
  qtsvg,
  qtwebengine,
  shared-mime-info,
}:

mkKdeDerivation {
  pname = "calligra";

  patches = [
    # Fix build with Poppler 25.10
    (fetchpatch {
      url = "https://invent.kde.org/office/calligra/-/commit/45e8b302bce1d318f310ea13599d7ce84acc477e.patch";
      hash = "sha256-TECB3eo24+gI8TXL8gw9BIdFWqw0JBKCWpoNVqBSan8=";
    })
  ];

  extraBuildInputs = [
    boost
    eigen
    gsl
    imath
    libetonyek
    libgit2
    libodfgen
    librevenge
    libvisio
    libwpd
    libwpg
    libwps
    okular
    poppler
    qtkeychain
    qtsvg
    qtwebengine
  ];

  extraNativeBuildInputs = [
    perl
    pkg-config
    shared-mime-info
  ];

  # Recommended by the upstream packaging instructions. RELEASE_BUILD disables
  # unmaintained components, like Braindump, from being built, and KDE_NO_DEBUG_OUTPUT
  # is supposed to improve performance in the finished package.
  extraCmakeFlags = [
    (lib.cmakeBool "RELEASE_BUILD" true)
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DKDE_NO_DEBUG_OUTPUT")
  ];

  meta = {
    maintainers = with lib.maintainers; [
      ebzzry
      zraexy
      sigmasquadron
    ];
    mainProgram = "calligralauncher";
  };
}
