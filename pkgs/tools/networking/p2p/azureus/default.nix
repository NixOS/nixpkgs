{lib, stdenv, fetchurl, jdk, swt}:

stdenv.mkDerivation {
  name = "azureus-2.3.0.6";

  src = fetchurl {
    url = "http://tarballs.nixos.org/Azureus2.3.0.6.jar";
    sha256 = "1hwrh3n0b0jbpsdk15zrs7pw175418phhmg6pn4xi1bvilxq1wrd";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/jars
    cp $src $out/jars/azureus.jar

    mkdir -p $out/bin
    cat > $out/bin/azureus <<EOF
    #! $SHELL -e
    azureusHome=$out
    if test -n "\$HOME"; then
        azureusHome=\$HOME/.Azureus
    fi
    exec ${jdk}/bin/java -Xms16m -Xmx128m \
      -cp $out/jars/azureus.jar:${swt}/jars/swt.jar \
      -Djava.library.path=$swt/lib \
      -Dazureus.install.path=\$azureusHome \
      org.gudy.azureus2.ui.swt.Main
    EOF
    chmod +x $out/bin/azureus
  '';

  meta = {
    platforms = lib.platforms.linux;
  };
}
