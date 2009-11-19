a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    mesa SDL SDL_mixer SDL_image

  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  preBuild = a.fullDepEntry (''
    sed -e "s@/usr/games@$out/bin@g" -i Makefile
    sed -e "s@/usr/@$out/@g" -i Makefile
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${a.SDL}/include/SDL"
  '') ["minInit" "addInputs" "doUnpack"];

  /* doConfigure should be removed if not needed */
  phaseNames = ["preBuild" "doMakeInstall"];
      
  meta = {
    description = "A physics-based game";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux ++ darwin;
  };
}
