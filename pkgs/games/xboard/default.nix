a:  
let 
  fetchurl = a.fetchurl;

  buildInputs = with a; [
    libX11 xproto libXt libXaw libSM libICE libXmu 
    libXext gnuchess texinfo libXpm
  ];

  s = import ./src-for-default.nix;
in
rec {
  src = fetchurl {
    inherit(s) url;
    sha256 = s.hash;
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "preBuild" "doMakeInstall"];

  preBuild = a.fullDepEntry(''
    sed -e '/FIRST_CHESS_PROGRAM/s@gnuchessx@${a.gnuchess}/bin/gnuchessx@' -i xboard.h
    sed -e '/SECOND_CHESS_PROGRAM/s@gnuchessx@${a.gnuchess}/bin/gnuchessx@' -i xboard.h
  '') ["doUnpack" "minInit"];
      
  inherit(s) name;
  meta = {
    description = "XBoard - a chess board compatible with GNU Chess";
  };
}
