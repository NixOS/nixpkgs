args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.attrByPath ["version"] "0.5.1" args; 
  buildInputs = with args; [
    chipmunk sqlite curl zlib bzip2 libjpeg libpng
    freeglut mesa SDL SDL_mixer SDL_image SDL_net SDL_ttf 
    lua5 ode
  ];
in
rec {
  src = fetchurl {
    url = "http://download.tuxfamily.org/xmoto/xmoto/${version}/xmoto-${version}-src.tar.gz";
    sha256 = "1clfw4kr34gda9ml427n8mdkhj0hhlldibiq1ay88glqqwvgj2j2";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "xmoto-" + version;
  meta = {
    description = "X-Moto - obstacled race game";
  };
}
