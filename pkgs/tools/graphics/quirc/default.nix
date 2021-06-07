{ lib, stdenv, fetchFromGitHub
, SDL_gfx, SDL, libjpeg, libpng, pkg-config
}:

stdenv.mkDerivation {
  pname = "quirc";
  version = "2020-04-16";

  src = fetchFromGitHub {
    owner = "dlbeer";
    repo = "quirc";
    rev = "ed455904f35270888bc902b9e8c0c9b3184a8302";
    sha256 = "1kqqvcnxcaxdgls9sibw5pqjz3g1gys2v64i4kfqp8wfcgd9771q";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL SDL_gfx libjpeg libpng ];

  makeFlags = [ "PREFIX=$(out)" ];
  NIX_CFLAGS_COMPILE = "-I${SDL.dev}/include/SDL -I${SDL_gfx}/include/SDL";

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
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
