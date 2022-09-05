{ lib
, stdenv
, fetchurl
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "npush";
  version = "0.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/npush/${pname}/${version}/${pname}-${version}.tgz";
    hash = "sha256-8hbSsyeehzd4T3fUhDyebyI/oTHOHr3a8ArYAquivNk=";
  };

  outputs = [ "out" "doc" ];

  buildInputs = [
    ncurses
  ];

  dontConfigure = true;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}c++"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/npush/levels $doc/share/doc/npush
    cp npush $out/bin/
    cp levels/* $out/share/npush/levels
    cp CHANGES COPYING CREDITS index.html \
       readme.txt screenshot1.png screenshot2.png $doc/share/doc/npush/

    runHook postInstall
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "http://npush.sourceforge.net/";
    description = "A Sokoban-like game";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
