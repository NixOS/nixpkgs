{ stdenv, fetchurl, makeDesktopItem, makeWrapper, premake4, unzip
, openal, libpng, libvorbis, libGLU, SDL2, SDL2_image, SDL2_ttf }:

let
  pname = "tome4";

  desktop = makeDesktopItem {
    desktopName = pname;
    name = pname;
    exec = "@out@/bin/${pname}";
    icon = "${pname}";
    terminal = "False";
    comment = "An open-source, single-player, role-playing roguelike game set in the world of Eyal.";
    type = "Application";
    categories = "Game;RolePlaying;";
    genericName = pname;
  };

in stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "1.5.5";

  src = fetchurl {
    url = "https://te4.org/dl/t-engine/t-engine4-src-${version}.tar.bz2";
    sha256 = "0v2qgdfpvdzd1bcbp9v8pfahj1bgczsq2d4xfhh5wg11jgjcwz03";
  };

  nativeBuildInputs = [ premake4 makeWrapper unzip ];

  # tome4 vendors quite a few libraries so someone might want to look into avoiding that...
  buildInputs = [
    libGLU openal libpng libvorbis SDL2 SDL2_ttf SDL2_image
  ];

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [
    "-I${SDL2_image}/include/SDL2"
    "-I${SDL2_ttf}/include/SDL2"
  ];

  postPatch = ''
    substituteInPlace premake4.lua \
      --replace "/opt/SDL-2.0/include/SDL2" "${SDL2.dev}/include/SDL2" \
      --replace "/usr/include/GL" "/run/opengl-driver/include"
  '';

  preConfigure = ''
    premake4 gmake
  '';

  makeFlags = [ "config=release" ];

  # The wrapper needs to cd into the correct directory as tome4's detection of
  # the game asset root directory is faulty.

  installPhase = ''
    runHook preInstall

    dir=$out/share/${pname}

    install -Dm755 t-engine $dir/t-engine
    cp -r bootstrap game $dir
    makeWrapper $dir/t-engine $out/bin/${pname} \
      --run "cd $dir"

    install -Dm755 ${desktop}/share/applications/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --subst-var out

    unzip -oj -qq game/engines/te4-${version}.teae data/gfx/te4-icon.png
    install -Dm644 te4-icon.png $out/share/icons/hicolor/64x64/${pname}.png

    install -Dm644 -t $out/share/doc/${pname} CONTRIBUTING COPYING COPYING-MEDIA CREDITS

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Tales of Maj'eyal (rogue-like game)";
    homepage = https://te4.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ chattered peterhoeg ];
    platforms = platforms.linux;
  };
}
