{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL_gfx,
  SDL,
  libjpeg,
  libpng,
  opencv,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quirc";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "dlbeer";
    repo = "quirc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zdq/YKL33jJXa10RqmQIl06rRYnrthWG+umT4dipft0=";
  };

  postPatch = ''
    # don't try to change ownership
    substituteInPlace Makefile \
      --replace-fail "-o root" "" \
      --replace-fail "-g root" ""
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL
    SDL_gfx
    libjpeg
    libpng
    opencv
  ];

  makeFlags = [ "PREFIX=$(out)" ];
  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL}/include/SDL -I${SDL_gfx}/include/SDL";

  # Disable building of linux-only demos on darwin systems
  patches = lib.optionals stdenv.isDarwin [ ./0001-dont-build-demos.patch ];

  buildPhase = lib.optionalString stdenv.isDarwin ''
    runHook preBuild
    make libquirc.so
    make qrtest
    runHook postBuild
  '';

  preInstall = ''
    mkdir -p "$out"/{bin,lib,include}

    # install all binaries
    find -maxdepth 1 -type f -executable ! -name '*.so.*' | xargs cp -t "$out"/bin
  '';

  postInstall = ''
    # don't install static library
    rm $out/lib/libquirc.a

    ln -s $out/lib/libquirc.so.* $out/lib/libquirc.so
  '';

  meta = {
    description = "A small QR code decoding library";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux ++ [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
