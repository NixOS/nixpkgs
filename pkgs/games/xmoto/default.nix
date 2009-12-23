a :  
let 
  s = import ./src-for-default.nix;
  buildInputs = with a; [
    chipmunk sqlite curl zlib bzip2 libjpeg libpng
    freeglut mesa SDL SDL_mixer SDL_image SDL_net SDL_ttf 
    lua5 ode
  ];
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = [ "doPatch" "doConfigure" "doMakeInstall"];

  patches = [ ./64bit-ftbs.patch ];
      
  meta = {
    description = "X-Moto - obstacled race game";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = with a.lib.platforms; 
      linux ++ freebsd;
  };
}
