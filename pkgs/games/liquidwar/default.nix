a :  
let 
  s = import ./src-for-default.nix;
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
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
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
