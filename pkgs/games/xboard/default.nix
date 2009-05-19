a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.getAttr ["version"] "4.2.7" a; 
  buildInputs = with a; [
    libX11 xproto libXt libXaw libSM libICE libXmu 
    libXext gnuchess
  ];
in
rec {
  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/xboard/xboard-${version}.tar.gz";
    sha256 = "0fwdzcav8shvzi7djphrlav29vwxnx63spzsldlhrglr7qpg28av";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "preBuild" "doMakeInstall"];

  preBuild = a.fullDepEntry(''
    sed -e '/FIRST_CHESS_PROGRAM/s@gnuchessx@${a.gnuchess}/bin/gnuchessx@' -i xboard.h
    sed -e '/SECOND_CHESS_PROGRAM/s@gnuchessx@${a.gnuchess}/bin/gnuchessx@' -i xboard.h
  '') ["doUnpack" "minInit"];
      
  name = "xboard-" + version;
  meta = {
    description = "XBoard - a chess board compatible with GNU Chess";
  };
}
