{ lib
, stdenv
, fetchurl
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, SDL
, SDL_mixer
, libintl
, libpng
, zlib
}:

stdenv.mkDerivation rec {
  pname = "lbreakout2";
  version = "2.6.5";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    sha256 = "0vwdlyvh7c4y80q5vp7fyfpzbqk9lq3w8pvavi139njkalbxc14i";
  };

<<<<<<< HEAD
  # Can't exit from pause without this patch
  patches = [(fetchpatch {
    url = "https://sources.debian.org/data/main/l/lbreakout2/2.6.5-2/debian/patches/sdl_fix_pauses.patch";
    hash = "sha256-ycsuxfokpOblLky42MwtJowdEp7v5dZRMFIR4id4ZBI=";
  })];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    SDL
    SDL_mixer
    libintl
    libpng
    zlib
  ];

<<<<<<< HEAD
  # With fortify it crashes at runtime:
  #   *** buffer overflow detected ***: terminated
  #   Aborted (core dumped)
  hardeningDisable = [ "fortify" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    homepage = "http://lgames.sourceforge.net/LBreakout2/";
    description = "Breakout clone from the LGames series";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ciil ];
    platforms = platforms.unix;
    hydraPlatforms = lib.platforms.linux; # sdl-config times out on darwin
  };
}
