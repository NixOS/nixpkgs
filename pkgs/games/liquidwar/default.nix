a :  
let 
  buildInputs = with a; [
    xproto libX11 gmp guile
    mesa libjpeg libpng
    expat gettext perl
    SDL SDL_image SDL_mixer SDL_ttf
    curl sqlite 
    libogg libvorbis
    libXrender
  ];
in
rec {
  name = "liquidwar6-0.0.13beta";

  src = a.fetchurl {
    url = "http://ftp.gnu.org/gnu/liquidwar6/${name}.tar.gz";
    sha256 = "1jjf7wzb8jf02hl3473vz1q74fhmxn0szbishgi1f1j6a7234wx2";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["setVars" "doConfigure" "doMakeInstall"];

  setVars = a.noDepEntry (''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${a.SDL}/include/SDL"
  '');
      
  meta = {
    description = "Quick tactics game";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux;
  };
}
