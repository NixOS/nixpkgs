{ lib, stdenv, fetchurl, autoreconfHook, pkg-config
, libglvnd, SDL, SDL_image, SDL_mixer, xorg
}:

stdenv.mkDerivation rec {
  pname = "pinball";
  version = "0.3.20201218";

  src = fetchurl {
    url = "mirror://sourceforge/pinball/pinball-${version}.tar.gz";
    sha256 = "0vacypp3ksq1hs6hxpypx7nrfkprbl4ksfywcncckwrh4qcir631";
  };

  postPatch = ''
    sed -i 's/^AUTOMAKE_OPTIONS = gnu$/AUTOMAKE_OPTIONS = foreign/' Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libglvnd SDL SDL_image SDL_mixer xorg.libSM ];
  strictDeps = true;

  configureFlags = [
    "--with-sdl-prefix=${lib.getDev SDL}"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${lib.getDev SDL_image}/include/SDL"
    "-I${lib.getDev SDL_mixer}/include/SDL"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://purl.org/rzr/pinball";
    description = "Emilia Pinball simulator";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.linux;
  };
}
