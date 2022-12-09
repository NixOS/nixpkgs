{ pkgs, lib, stdenv, makeDesktopItem, fetchurl, unzip, makeWrapper, xorg, jre, }:

stdenv.mkDerivation rec {
  pname = "runelite";
  version = "2.1.5";

  jar = fetchurl {
    url = "https://github.com/runelite/launcher/releases/download/${version}/RuneLite.jar";
    sha256 = "4BX188QIjIFTxng2ktqlKn7AqQ9tdBcKWmgOj/5yd10=";
  };

  icon = fetchurl {
    url = "https://github.com/runelite/launcher/raw/${version}/appimage/runelite.png";
    sha256 = "04fcjm7p546gr82g0jbh497j7rnh70lrvas0k171bff4v3knrjw1";
  };

  # The `.so` files provided by these two jars aren't detected by RuneLite for some reason, so we have to provide them manually
  jogl = fetchurl {
    url = "https://repo.runelite.net/net/runelite/jogl/jogl-all/2.4.0-rc-20200429/jogl-all-2.4.0-rc-20200429-natives-linux-amd64.jar";
    sha256 = "S60qxyWY9RfyhLFygn/OxZFWnc8qVRtTFdWMbdu+2U0=";
  };
  gluegen = fetchurl {
    url = "https://repo.runelite.net/net/runelite/gluegen/gluegen-rt/2.4.0-rc-20200429/gluegen-rt-2.4.0-rc-20200429-natives-linux-amd64.jar";
    sha256 = "eF8S5sQkJFDtW8rcVBKIyeyKm5Ze5rXK5r/yosZcHjU=";
  };
  dontUnpack = true;

  desktop = makeDesktopItem {
    name = "RuneLite";
    type = "Application";
    exec = "runelite";
    icon = icon;
    comment = "Open source Old School RuneScape client";
    desktopName = "RuneLite";
    genericName = "Oldschool Runescape";
    categories = [ "Game" ];
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  installPhase = ''
    mkdir -p $out/share/runelite
    mkdir -p $out/share/applications
    mkdir -p $out/natives

    unzip ${jogl}    'natives/*' -d $out
    unzip ${gluegen} 'natives/*' -d $out

    ln -s ${jar} $out/share/runelite/RuneLite.jar
    ln -s ${desktop}/share/applications/RuneLite.desktop $out/share/applications/RuneLite.desktop

    # RuneLite looks for `.so` files in $PWD/natives, so ensure that we set the PWD to the right place
    makeWrapper ${jre}/bin/java $out/bin/runelite \
      --chdir "$out" \
      --prefix LD_LIBRARY_PATH : "${xorg.libXxf86vm}/lib" \
      --add-flags "-jar $out/share/runelite/RuneLite.jar"
  '';

  meta = with lib; {
    description = "Open source Old School RuneScape client";
    homepage = "https://runelite.net/";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.bsd2;
    maintainers = with maintainers; [ kmeakin ];
    platforms = [ "x86_64-linux" ];
  };
}
