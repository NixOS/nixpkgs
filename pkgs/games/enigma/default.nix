{ lib, stdenv, fetchurl, makeWrapper, pkg-config, gettext, imagemagick, curl, libpng, SDL2, SDL2_image, SDL2_mixer, SDL2_ttf, xercesc, xdg-utils, hicolor-icon-theme }:
stdenv.mkDerivation rec {
  pname = "enigma";
  version = "1.30-alpha";

  src = fetchurl {
    url = "https://github.com/Enigma-Game/Enigma/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "1zyk3j43gzfr1lhc6g13j7qai5f33fv5xm5735nnznaqvaz17949";
  };

  nativeBuildInputs = [ pkg-config gettext makeWrapper imagemagick ];
  buildInputs = [ SDL2 SDL2_image SDL2_mixer SDL2_ttf libpng xercesc curl xdg-utils ];

  # For some reason (might be related to the alpha status), some includes
  # which are required by lib-src/enigma-core are not picked up by the
  # configure script. Hence we add them manually.
  CPPFLAGS = "-I${SDL2.dev}/include/SDL2 -I${SDL2_ttf}/include/SDL2 -I${SDL2_image}/include/SDL2 -I${SDL2_mixer}/include/SDL2";

  postInstall = ''
    rm -r $out/include
    wrapProgram $out/bin/enigma --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}"
  '';

  meta = with lib; {
    description = "Puzzle game inspired by Oxyd on the Atari ST and Rock'n'Roll on the Amiga";
    license = with licenses; [ gpl2 free ]; # source + bundles libs + art
    platforms = platforms.unix;
    broken = stdenv.targetPlatform.isDarwin;
    maintainers = with maintainers; [ iblech ];
    homepage = "https://www.nongnu.org/enigma/";
  };
}
