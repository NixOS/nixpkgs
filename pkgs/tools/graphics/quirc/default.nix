{ lib, stdenv, fetchFromGitHub, SDL_gfx, SDL, libjpeg, libpng, opencv
, pkg-config }:

stdenv.mkDerivation {
  pname = "quirc";
  version = "2021-10-08";

  src = fetchFromGitHub {
    owner = "dlbeer";
    repo = "quirc";
    rev = "516d91a94d880ca1006fc1d57f318bdff8411f0d";
    sha256 = "0jkaz5frm6jr9bxyfympvzh180nczrfvvb3z3qhk21djlas6nr5f";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL SDL_gfx libjpeg libpng opencv ];

  makeFlags = [ "PREFIX=$(out)" ];
  NIX_CFLAGS_COMPILE = "-I${lib.getDev SDL}/include/SDL -I${SDL_gfx}/include/SDL";

  # Disable building of linux-only demos on darwin systems
  patches = lib.optionals stdenv.isDarwin [ ./0001-dont-build-demos.patch ];

  buildPhase = lib.optionalString stdenv.isDarwin ''
    runHook preBuild
    make libquirc.so
    make qrtest
    runHook postBuild
  '';

  configurePhase = ''
    runHook preConfigure

    # don't try to change ownership
    sed -e 's/-[og] root//g' -i Makefile

    runHook postConfigure
  '';

  preInstall = ''
    mkdir -p "$out"/{bin,lib,include}

    # install all binaries
    find -maxdepth 1 -type f -executable ! -name '*.so.*' | xargs cp -t "$out"/bin
  '';

  meta = {
    description = "A small QR code decoding library";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux ++ [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
