{ lib, stdenv, fetchFromGitHub, makeDesktopItem, makeWrapper, cmake, libjpeg, zlib, libpng, libGL, SDL2
, unstableGitUpdater
}:

let
  jamp = makeDesktopItem rec {
    name = "jamp";
    exec = name;
    icon = "OpenJK_Icon_128";
    comment = "Open Source Jedi Academy game released by Raven Software";
    desktopName = "Jedi Academy (Multi Player)";
    genericName = "Jedi Academy";
    categories = [ "Game" ];
  };
  jasp = makeDesktopItem rec {
    name = "jasp";
    exec = name;
    icon = "OpenJK_Icon_128";
    comment = "Open Source Jedi Academy game released by Raven Software";
    desktopName = "Jedi Academy (Single Player)";
    genericName = "Jedi Academy";
    categories = [ "Game" ];
  };
  josp = makeDesktopItem rec {
    name = "josp";
    exec = name;
    icon = "OpenJK_Icon_128";
    comment = "Open Source Jedi Outcast game released by Raven Software";
    desktopName = "Jedi Outcast (Single Player)";
    genericName = "Jedi Outcast";
    categories = [ "Game" ];
  };
in stdenv.mkDerivation {
  pname = "openjk";
  version = "0-unstable-2024-04-07";

  src = fetchFromGitHub {
    owner = "JACoders";
    repo = "OpenJK";
    rev = "2815211a87ccb8de1b0ee090d429a63f47e0ac7a";
    hash = "sha256-F3JF6jFgyMinIZ7dZAJ0ugGrJFianh2b6dX5A4iEnns=";
  };

  dontAddPrefix = true;

  nativeBuildInputs = [ makeWrapper cmake ];
  buildInputs = [ libjpeg zlib libpng libGL SDL2 ];

  outputs = [ "out" "openjo" "openja" ];

  # move from $out/JediAcademy to $out/opt/JediAcademy
  preConfigure = ''
    cmakeFlagsArray=("-DCMAKE_INSTALL_PREFIX=$out/opt")
  '';
  cmakeFlags = ["-DBuildJK2SPEngine:BOOL=ON"
                "-DBuildJK2SPGame:BOOL=ON"
                "-DBuildJK2SPRdVanilla:BOOL=ON"];

  postInstall = ''
    mkdir -p $out/bin $openja/bin $openjo/bin
    mkdir -p $openja/share/applications $openjo/share/applications
    mkdir -p $openja/share/icons/hicolor/128x128/apps $openjo/share/icons/hicolor/128x128/apps
    mkdir -p $openja/opt $openjo/opt
    mv $out/opt/JediAcademy $openja/opt/
    mv $out/opt/JediOutcast $openjo/opt/
    jaPrefix=$openja/opt/JediAcademy
    joPrefix=$openjo/opt/JediOutcast

    makeWrapper $jaPrefix/openjk.* $openja/bin/jamp --chdir "$jaPrefix"
    makeWrapper $jaPrefix/openjk_sp.* $openja/bin/jasp --chdir "$jaPrefix"
    makeWrapper $jaPrefix/openjkded.* $openja/bin/openjkded --chdir "$jaPrefix"
    makeWrapper $joPrefix/openjo_sp.* $openjo/bin/josp --chdir "$joPrefix"

    cp $src/shared/icons/OpenJK_Icon_128.png $openjo/share/icons/hicolor/128x128/apps
    cp $src/shared/icons/OpenJK_Icon_128.png $openja/share/icons/hicolor/128x128/apps
    ln -s ${jamp}/share/applications/* $openja/share/applications
    ln -s ${jasp}/share/applications/* $openja/share/applications
    ln -s ${josp}/share/applications/* $openjo/share/applications
    ln -s $openja/bin/* $out/bin
    ln -s $openjo/bin/* $out/bin
    rm -rf $out/opt
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Open-source engine for Star Wars Jedi Academy game";
    homepage = "https://github.com/JACoders/OpenJK";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tgunnoe ];
  };
}
