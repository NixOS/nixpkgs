{
  lib,
  stdenv,
  fetchFromGitLab,
  d0_blind_id,
  gmp,
  libjpeg,
  zlib,
  libvorbis,
  libpng,
  libtheora,
  freetype,
  curl,
  SDL2,
  libx11,
  libGLU,
  libGL,
  libxpm,
  libxext,
  libxxf86vm,
  alsa-lib,
}:

let
  inherit (stdenv.hostPlatform) isLinux isDarwin;

  targets =
    # dedicated server always
    [ "sv-release" ]
    ++ lib.optional (isLinux || isDarwin) "sdl-release"
    # GLX is Linux-only
    ++ lib.optional isLinux "cl-release";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xonotic-darkplaces";
  version = "0.8.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "xonotic";
    repo = "darkplaces";
    rev = "xonotic-v${finalAttrs.version}";
    hash = "sha256-rNG9scpgwE5T7iUvzfzMUYmqM0Os8CRkIe1X54JZSRw=";
  };

  patches = [ ./fix-build-with-c23.patch ];

  postPatch = lib.optionalString isDarwin ''
    substituteInPlace makefile.inc \
      --replace 'LDFLAGS_BSDSDL=$(LDFLAGS_UNIXCOMMON) $(LDFLAGS_UNIXSDL)' \
                'LDFLAGS_BSDSDL=$(LDFLAGS_UNIXCOMMON) $(LDFLAGS_UNIXSDL) -framework IOKit'
  '';

  buildInputs = [
    d0_blind_id
    gmp
    libjpeg
    zlib
    libvorbis
    libpng
    libtheora
    freetype
    curl
    SDL2
    libx11
  ]
  ++ lib.optionals isLinux [
    libGLU
    libGL
    libxpm
    libxext
    libxxf86vm
    alsa-lib
  ];

  # Set crypto flags as env so sub-makes inherit them.
  # DP_LINK_CRYPTO=foo avoids matching "shared"/"dlopen" conditionals.
  makeFlags = [
    "DP_LINK_CRYPTO=foo"
    "CFLAGS_CRYPTO=-DLINK_TO_CRYPTO"
    "LIB_CRYPTO=-ld0_blind_id -lgmp"
    "DP_LINK_CRYPTO_RIJNDAEL=shared"
    "DP_PRELOAD_DEPENDENCIES=1"
  ];

  env = lib.optionalAttrs isDarwin {
    DP_MAKE_TARGET = "bsd";
    DP_SOUND_API = "COREAUDIO";
    SDL2_PATH = "${lib.getDev SDL2}/include/SDL2";
  };

  NIX_CFLAGS_COMPILE = [ "-I${d0_blind_id}/include" ];
  NIX_LDFLAGS = [ "-L${d0_blind_id}/lib" ];

  buildPhase = ''
    runHook preBuild
    ${lib.concatStringsSep "\n" (map (t: "make -j $NIX_BUILD_CORES " + t) targets)}
    runHook postBuild
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 darkplaces-dedicated $out/bin/
    ${lib.optionalString (isLinux || isDarwin) "install -m755 darkplaces-sdl $out/bin/"}
    ${lib.optionalString isLinux "install -m755 darkplaces-glx $out/bin/"}
    runHook postInstall
  '';

  meta = {
    description = "DarkPlaces engine built for Xonotic";
    homepage = "https://gitlab.com/xonotic/darkplaces";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ zalakain ];
  };
})
