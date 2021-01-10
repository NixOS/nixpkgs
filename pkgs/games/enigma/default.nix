{ stdenv, fetchurl, makeWrapper, pkg-config, curl, imagemagick, libpng, SDL, SDL_image, SDL_mixer, SDL_ttf, xercesc, xdg_utils, hicolor-icon-theme }:
stdenv.mkDerivation rec {
  pname = "enigma";
  version = "1.21";

  src = fetchurl {
    url = "mirror://sourceforge/enigma-game/enigma-${version}.tar.gz";
    sha256 = "d872cf067d8eb560d3bb1cb17245814bc56ac3953ae1f12e2229c8eb6f82ce01";
  };

  # patches lifted from Arch
  patches = [ ./src_client.cc.patch ./src_lev_Proxy.cc.patch ./src_Value.cc.patch ];

  NIX_CFLAGS_COMPILE = [ "-Wno-deprecated-declarations" ];

  nativeBuildInputs = [ pkg-config imagemagick makeWrapper ];
  buildInputs = [ SDL SDL_image SDL_mixer SDL_ttf libpng xercesc curl xdg_utils ];

  postInstall = ''
    rm -r $out/include
    wrapProgram $out/bin/enigma --prefix PATH : "${stdenv.lib.makeBinPath [ xdg_utils ]}"
  '';

  meta = with stdenv.lib; {
    description = "Puzzle game inspired by Oxyd on the Atari ST and Rock'n'Roll on the Amiga";
    license = with licenses; [ gpl2 free ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ iblech ];
    homepage = "https://www.nongnu.org/enigma/";
  };
}
