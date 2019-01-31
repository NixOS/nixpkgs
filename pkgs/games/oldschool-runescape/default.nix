{ stdenv, fetchurl, makeDesktopItem, p7zip, cabextract, jre }:

let
  desktopItem = makeDesktopItem {
    name = "OSRuneScape";
    exec = "oldschool-runescape";
    icon = "jagexappletviewer";
    terminal = "false";
    comment = "An MMO based off of the 2007 version of RuneScape";
    type = "Application";
    categories = "Game;RolePlaying;";
    desktopName = "Old School RuneScape";
    genericName = "Old School RuneScape";
    startupNotify = "false";
  };
in stdenv.mkDerivation rec {
  name = "oldschool-runescape";

  src = fetchurl {
    name = "oldschool.msi";
    url = http://www.runescape.com/downloads/oldschool.msi?1548915139541;
    sha256 = "1h0h7wakr20k2kq01yap45wfz9y47flqd0sr2grg7fya8hsbmgqb";
  };

  phases = [ "buildPhase" "installPhase" ];

  nativeBuildInputs = [ p7zip cabextract ];

  buildInputs = [ jre ];

  buildPhase = ''
    ${p7zip}/bin/7z x ${src}
    ${cabextract}/bin/cabextract rslauncher.cab

    mv JagexAppletViewerJarFile.F77C1A97_9A40_44D4_983D_751571B24CE4 jagexappletviewer.jar
    mv JagexAppletViewerPngFile jagexappletviewer.png
  '';

  installPhase = ''
    mkdir -p $out/share $out/bin

    cp -r ${desktopItem}/share/applications $out/share
    install -Dm644 jagexappletviewer.png $out/share/icons/hicolor/64x64/jagexappletviewer.png
    install -Dm644 jagexappletviewer.jar $out/share/java/jagexappletviewer.jar

    cat > $out/bin/oldschool-runescape <<EOF
    #! $shell
    if [ ! -d "\$USER/.jagexclient" ]
    then
      mkdir -p \$USER/.jagexclient/images
      cp $out/share/icons/hicolor/64x64/jagexappletviewer.png \$USER/.jagexclient/images
    fi

    exec ${jre}/bin/java -Dsun.java2d.uiScale=2.5 -Djava.class.path=$out/share/java/jagexappletviewer.jar \
                         -Dcom.jagex.config=http://oldschool.runescape.com/jav\_config.ws \
                         -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2 \
                         jagexappletviewer \$USER/.jagexclient/images
    EOF

    chmod a+x $out/bin/oldschool-runescape
  '';

  meta = with stdenv.lib; {
    homepage = https://oldschool.runescape.com;
    description = "Old School Runescape is an MMO based off of the 2007 version of RuneScape";
    maintainers = [ maintainers.MP2E ];
    platforms = platforms.unix;
    license = licenses.unfreeRedistributable;
  };
}
