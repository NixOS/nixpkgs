{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  imagemagick,
  libpng,
  glib,
  pkg-config,
  libgsf,
  libxml2,
  bzip2,
  autoreconfHook,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wv";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "AbiWord";
    repo = "wv";
    rev = "wv-${builtins.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-xcC+/M1EzFqQFeF5Dw9qd8VIy7r8JdKMp2X/GHkFiPA=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    zlib
    imagemagick
    libpng
    glib
    libgsf
    libxml2
    bzip2
  ];

  configureFlags = [
    "PKG_CONFIG=${buildPackages.pkg-config}/bin/${buildPackages.pkg-config.targetPrefix}pkg-config"
  ];

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  # autoreconfHook fails hard if these two files do not exist
  postPatch = ''
    touch AUTHORS ChangeLog
  '';

  meta = {
    homepage = "https://github.com/AbiWord/wv";
    description = "Converter from Microsoft Word formats to human-editable ones";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
})
