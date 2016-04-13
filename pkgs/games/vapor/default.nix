{ stdenv, fetchurl, love, lua, makeWrapper, makeDesktopItem }:

let
  pname = "vapor";
  version = "0.2.3";
  commitid = "dbf509f";

  icon = fetchurl {
    url = "http://vapor.love2d.org/sites/default/files/vapT240x90.png";
    sha256 = "1xlra74lpm1y54z6zm6is0gldkswp3wdw09m6a306ch0xjf3f87f";
  };

  desktopItem = makeDesktopItem {
    name = "Vapor";
    exec = "${pname}";
    icon = "${icon}";
    comment = "LÖVE Distribution Client"; 
    desktopName = "Vapor";
    genericName = "vapor";
    categories = "Game;";
  };

in 

stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url =
    "https://github.com/josefnpat/${pname}/releases/download/${version}/${pname}_${commitid}.love";
    sha256 = "0w2qkrrkzfy4h4jld18apypmbi8a8r89y2l11axlv808i2rg68fk";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ lua love ];

  phases = "installPhase";

  installPhase =
  ''
    mkdir -p $out/bin
    mkdir -p $out/share

    cp -v $src $out/share/${pname}.love

    makeWrapper ${love}/bin/love $out/bin/${pname} --add-flags $out/share/${pname}.love

    chmod +x $out/bin/${pname}
    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = with stdenv.lib; {
    description = "LÖVE Distribution Client allowing access to many games";
    platforms = platforms.linux;
    license = licenses.zlib;
    maintainers = with maintainers; [ leenaars ];
    downloadPage = http://vapor.love2d.org/;
  };

}
