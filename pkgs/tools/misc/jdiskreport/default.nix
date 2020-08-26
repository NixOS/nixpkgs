{ stdenv, fetchurl, unzip, jre, makeDesktopItem }:

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

  buildInputs = [ unzip ];
  inherit jre;

  installPhase = ''
    source $stdenv/setup

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

    ${desktopItem.buildCommand}
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.jgoodies.com/freeware/jdiskreport/";
    description = "A graphical utility to visualize disk usage";
    license = licenses.unfreeRedistributable; #TODO freedist, libs under BSD-3
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ kylesferrazza ];
  };
}
