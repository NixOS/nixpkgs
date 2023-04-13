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
  version = "2.2.0";

  src = fetchurl {
    urls = map (mirror: "${mirror}/${finalAttrs.version}/i2psource_${finalAttrs.version}.tar.bz2") [
      "https://download.i2p2.de/releases"
      "https://files.i2p-projekt.de"
      "https://download.i2p2.no/releases"
    ];
    sha256 = "sha256-5LoGpuKTWheZDwV6crjXnkUqJVamzv5QEtXdY0Zv7r8=";
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
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ joelmo ];
  };
})
