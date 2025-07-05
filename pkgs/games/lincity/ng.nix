{
  stdenv,
  SDL2,
  SDL2_gfx,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  cmake,
  fetchFromGitHub,
  lib,
  libGL,
  libGLU,
  libwebp,
  libtiff,
  libX11,
  libxml2,
  libxmlxx5,
  libxslt,
  physfs,
  pkg-config,
  xorgproto,
  zlib,
  gettext,
  include-what-you-use,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lincity-ng";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "lincity-ng";
    repo = "lincity-ng";
    rev = "lincity-ng-${finalAttrs.version}";
    hash = "sha256-ACJVhMq2IEJNrbAdmkgHxQV0uKSXpwR8a/5jcrQS+oI=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gettext
    include-what-you-use
    libxml2
  ];

  buildInputs = [
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    libGL
    libGLU
    libX11
    libwebp
    libtiff
    libxmlxx5
    libxml2
    libxslt
    physfs
    xorgproto
    zlib
  ];

  cmakeFlags = [
    "-DLIBXML2_LIBRARY=${lib.getLib libxml2}/lib/libxml2${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DLIBXML2_XMLCATALOG_EXECUTABLE=${lib.getBin libxml2}/bin/xmlcatalog"
    "-DLIBXML2_XMLLINT_EXECUTABLE=${lib.getBin libxml2}/bin/xmllint"
  ];

  env.NIX_CFLAGS_COMPILE = "
    -I${lib.getDev SDL2_image}/include/SDL2
    -I${lib.getDev SDL2_mixer}/include/SDL2
  ";

  meta = with lib; {
    description = "City building game";
    mainProgram = "lincity-ng";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
})
