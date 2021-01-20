{ lib, stdenv, fetchurl, unzip, jre, makeDesktopItem, copyDesktopItems }:

let
  desktopItem = makeDesktopItem {
    desktopName = "JDiskReport";
    genericName = "A graphical utility to visualize disk usage";
    categories = "Utility;";
    exec = "jdiskreport";
    name = "jdiskreport";
    type = "Application";
  };
in
stdenv.mkDerivation {
  name = "jdiskreport-1.4.1";

  src = fetchurl {
    url = "http://www.jgoodies.com/download/jdiskreport/jdiskreport-1_4_1.zip";
    sha256 = "0d5mzkwsbh9s9b1vyvpaawqc09b0q41l2a7pmwf7386b1fsx6d58";
  };

  nativeBuildInputs = [ copyDesktopItems ];
  buildInputs = [ unzip ];
  inherit jre;

  installPhase = ''
    runHook preInstall

    unzip $src

    jar=$(ls */*.jar)

    mkdir -p $out/share/java
    mv $jar $out/share/java

    mkdir -p $out/bin
    cat > $out/bin/jdiskreport <<EOF
    #! $SHELL -e
    exec $jre/bin/java -jar $out/share/java/$(basename $jar)
    EOF
    chmod +x $out/bin/jdiskreport

    runHook postInstall
  '';

  desktopItems = [ desktopItem ];

  meta = with lib; {
    homepage = "http://www.jgoodies.com/freeware/jdiskreport/";
    description = "A graphical utility to visualize disk usage";
    license = licenses.unfreeRedistributable; #TODO freedist, libs under BSD-3
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ kylesferrazza ];
  };
}
