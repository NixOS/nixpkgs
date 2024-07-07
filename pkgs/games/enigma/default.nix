{ lib, stdenv, fetchurl, fetchpatch, makeWrapper, pkg-config, gettext, imagemagick, curl, libpng, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, xercesc, xdg-utils, hicolor-icon-theme }:
stdenv.mkDerivation rec {
  pname = "enigma";
  version = "1.30";

  src = fetchurl {
    url = "https://github.com/Enigma-Game/Enigma/releases/download/${version}/Enigma-${version}-src.tar.gz";
    sha256 = "rmS5H7wrEJcAcdDXjtW07enuOGjeLm6VaVRvxYQ3+K8=";
  };

  patches = [
    # fix format string security warning (turned into error)
    (fetchpatch {
      url = "https://github.com/Enigma-Game/Enigma/pull/70/commits/d25051eb6228c885e779a9674f8ee3979da30663.patch";
      sha256 = "L5C4NCZDDUKji9Tg4geKaiw3CkSY6rCoawqGKqR4dFM=";
    })
  ];

  nativeBuildInputs = [ pkg-config gettext makeWrapper imagemagick ];
  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_ttf libpng xercesc curl xdg-utils ];

  # The configure script of enigma uses pkg-config to determine the header
  # directories of SDL2. However, pkg-config only returns the path to the core
  # SDL2 library, not to the additional libraries SDL2_ttf, SDL2_image and
  # SDL2_mixer. In contrast, sdl2-config does return the correct list of paths.
  # We don't use configureFlags here so that the shell can correctly carry
  # out the interpolation.
  preConfigure = ''
    export SDL_CFLAGS=$(sdl2-config --cflags)
  '';

  postInstall = ''
    rm -r $out/include
    # make xdg-open overrideable at runtime
    wrapProgram $out/bin/enigma --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"
  '';

  meta = with lib; {
    description = "Puzzle game inspired by Oxyd on the Atari ST and Rock'n'Roll on the Amiga";
    mainProgram = "enigma";
    license = with licenses; [ gpl2 free ]; # source + bundles libs + art
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ iblech ];
    homepage = "https://www.nongnu.org/enigma/";
  };
}
