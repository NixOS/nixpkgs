args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;

  version = lib.getAttr ["version"] "0.5.0" args; 
  buildInputs = with args; [
    chipmunk sqlite curl zlib bzip2 libjpeg libpng
    freeglut mesa SDL SDL_mixer SDL_image SDL_net SDL_ttf 
    lua5 ode
  ];
in
rec {
  src = fetchurl {
    url = "http://download.tuxfamily.org/xmoto/xmoto/${version}/xmoto-${version}-src.tar.gz";
    sha256 = "0gy9rjmjns4kbqfrdh9v1bg1w92xipxv3ia9w1wh2c58rp1p0nkh";
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
