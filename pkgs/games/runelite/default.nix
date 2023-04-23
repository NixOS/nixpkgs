{ pkgs, lib, stdenv, makeDesktopItem, fetchurl, unzip, makeWrapper, xorg, jre, }:

stdenv.mkDerivation rec {
  pname = "runelite";
  version = "2.5.0";

  jar = fetchurl {
    url = "https://github.com/runelite/launcher/releases/download/${version}/RuneLite.jar";
    hash = "sha512-uEvlxXtnq7pgt8H5/hYIMu/kl32/dNojcHrPW6n2/RD/nzywreDw4kZ3G1kx0gGBY71x0RIEseEbm4BM+fhJlQ==";
  };

  icon = fetchurl {
    url = "https://github.com/runelite/launcher/raw/${version}/appimage/runelite.png";
    hash = "sha512-Yh8mpc6z9xd6ePe3f1f+KzrpE9r3fsdtQ0pfAvOhK/0hrCo/17eQA6v73yFXZcPQogVwm9CmJlrx4CkfzB25RQ==";
  };

  # The `.so` files provided by these two jars aren't detected by RuneLite for some reason, so we have to provide them manually
  jogl = fetchurl {
    url = "https://repo.runelite.net/net/runelite/jogl/jogl-all/2.4.0-rc-20200429/jogl-all-2.4.0-rc-20200429-natives-linux-amd64.jar";
    hash = "sha512-OmJIbk5pKtvf1n1I5UHu6iaOKNrPgmaJTPhqC8yMjaRh/Hso1vV/+Eu+zKu7d5UiVggVUzJxqDKatmEnqFrzbg==";
  };
  gluegen = fetchurl {
    url = "https://repo.runelite.net/net/runelite/gluegen/gluegen-rt/2.4.0-rc-20220318/gluegen-rt-2.4.0-rc-20220318-natives-linux-amd64.jar";
    hash = "sha512-kF+RdDzYEhBuZOJ6ZwMhaEVcjYLxiwR8tYAm08FXDML45iP4HBEfmqHOLJpIakK06aQFj99/296vx810eDFX5A==";
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
