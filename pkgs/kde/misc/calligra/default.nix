{
  mkKdeDerivation,
  lib,
  fetchurl,
  boost,
  eigen,
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
}:

mkKdeDerivation rec {
  pname = "calligra";
  version = "4.0.1";

  src = fetchurl {
    url = "mirror://kde/stable/calligra/calligra-${version}.tar.xz";
    hash = "sha256-1AH15z9PG9wLNUjqGlCwrBd4we3jCmozWUTtf72I2V8=";
  };

  extraBuildInputs = [
    boost
    eigen
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
  ];

  extraNativeBuildInputs = [
    perl
    pkg-config
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
    license = with lib.licenses; [
      gpl2
      lgpl2
    ];
    mainProgram = "calligralauncher";
  };
}
