a :  
let 
  buildInputs = with a; [
    xproto libX11 gmp guile
    mesa libjpeg libpng
    expat gettext perl
    SDL SDL_image SDL_mixer SDL_ttf
    curl sqlite 
    libogg libvorbis csound
    libXrender libcaca cunit
  ];
in
rec {
  name = "liquidwar6-${meta.version}";

  src = a.fetchurl {
    url = "mirror://gnu/liquidwar6/${name}.tar.gz";
    sha256 = "1q58liqm5cgp494yjj6rfc2xj5b4gm8r8yvi46jzwqll353mabwl";
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
  homepage = "http://www.gnu.org/software/liquidwar6/";
  version = "0.4.3681";
  updateWalker=true;
  };
}
