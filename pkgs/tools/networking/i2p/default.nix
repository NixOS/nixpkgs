{ lib
, stdenv
, ps
, coreutils
, fetchurl
, jdk
, jre
, ant
, gettext
, which
, java-service-wrapper
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i2p";
  version = "2.4.0";

  src = fetchurl {
    urls = map (mirror: "${mirror}/${finalAttrs.version}/i2psource_${finalAttrs.version}.tar.bz2") [
      "https://download.i2p2.de/releases"
      "https://files.i2p-projekt.de"
      "https://download.i2p2.no/releases"
    ];
    sha256 = "sha256-MO+K/K0P/6/ZTTCsMH+GtaazGOLB9EoCMAWEGh/NB3w=";
  };

  buildInputs = [ jdk ant gettext which ];
  patches = [ ./i2p.patch ];

  buildPhase = ''
    export JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
    ant preppkg-linux-only
  '';

  installPhase = ''
    set -B
    mkdir -p $out/{bin,share}
    cp -r pkg-temp/* $out

    cp ${java-service-wrapper}/bin/wrapper $out/i2psvc
    cp ${java-service-wrapper}/lib/wrapper.jar $out/lib
    cp ${java-service-wrapper}/lib/libwrapper.so $out/lib

    sed -i $out/i2prouter -i $out/runplain.sh \
      -e "s#uname#${coreutils}/bin/uname#" \
      -e "s#which#${which}/bin/which#" \
      -e "s#%gettext%#${gettext}/bin/gettext#" \
      -e "s#/usr/ucb/ps#${ps}/bin/ps#" \
      -e "s#/usr/bin/tr#${coreutils}/bin/tr#" \
      -e "s#%INSTALL_PATH#$out#" \
      -e 's#%USER_HOME#$HOME#' \
      -e "s#%SYSTEM_java_io_tmpdir#/tmp#" \
      -e "s#%JAVA%#${jre}/bin/java#"
    mv $out/runplain.sh $out/bin/i2prouter-plain
    mv $out/man $out/share/
    chmod +x $out/bin/* $out/i2psvc
    rm $out/{osid,postinstall.sh,INSTALL-headless.txt}
  '';

  meta = with lib; {
    description = "Applications and router for I2P, anonymity over the Internet";
    homepage = "https://geti2p.net";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # source bundles dependencies as jars
    ];
    license = with licenses; [
      asl20
      boost
      bsd2
      bsd3
      cc-by-30
      cc0
      epl10
      gpl2
      gpl3
      lgpl21Only
      lgpl3Only
      mit
      publicDomain
    ];
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ joelmo ];
  };
})
