a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.5beta" a; 
  buildInputs = with a; [
    mesa libX11 xproto tcl freeglut
    SDL SDL_mixer libXi inputproto
    libXmu libXext xextproto libXt libSM libICE
    libpng pkgconfig gettext intltool
  ];
in
rec {
  src = fetchurl {
    url = "mirror://sourceforge/extremetuxracer/extremetuxracer-${version}.tar.gz";
    sha256 = "04d99fsfna5mc9apjxsiyw0zgnswy33kwmm1s9d03ihw6rba2zxs";
  };

  inherit buildInputs;
  configureFlags = [
  		"--with-tcl=${a.tcl}/lib"
  	];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];

  name = "extremetuxracer-" + version;
  meta = {
    description = "High speed arctic racing game based on Tux Racer";
    longDescription = ''
      ExtremeTuxRacer - Tux lies on his belly and accelerates down ice slopes.
    '';
  };
}
