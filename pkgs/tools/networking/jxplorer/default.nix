{ lib, stdenv, fetchurl, makeDesktopItem, ant, jdk8 }:

stdenv.mkDerivation rec {
  pname   = "jxplorer";
  version = "3.3.1.2";

  src = fetchurl {
    url    = "https://github.com/pegacat/${pname}/releases/download/v${version}/${pname}-${version}-project.tar.bz2";
    sha256 = "/lWkavH51OqNFSLpgT+4WcQcfW3WvnnOkB03jB7bE/s=";
  };

  jxplorerItem = makeDesktopItem {
    name = "JXplorer";
    exec = "jxplorer";
    comment = "A Java Ldap Browser";
    desktopName = "JXplorer";
    genericName = "Java Ldap Browser";
  };

  configurePhase = ''
    cat >"${pname}" << EOF
    #!/bin/sh
    cd "$out/opt/jxplorer"
    export JAVA_HOME="${jdk8}"
    sh jxplorer.sh "\$@"
    EOF
    chmod +x "${pname}"
  '';

  installPhase = ''
    install -d "$out/opt/jxplorer" "$out/bin" "$out/share/pixmaps" "$out/share/applications"
    cp -r ./. "$out/opt/jxplorer"
    install -Dm755 "${pname}" "$out/bin/${pname}"
    cp -r "${jxplorerItem}/." "$out"
    install -Dm644 images/JX128.png "$out/share/pixmaps/${pname}.png"
  '';

  meta = with lib; {
    description = "A Java Ldap Browser";
    homepage    = "https://sourceforge.net/projects/jxplorer/";
    license     = "CA Open Source Licence Version 1.0";
    maintainers = with maintainers; [ benwbooth ];
    platforms   = platforms.linux;
  };
}
