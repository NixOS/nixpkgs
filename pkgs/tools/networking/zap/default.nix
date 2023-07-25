{ lib, stdenv, fetchurl, jre, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "zap";
  version = "2.12.0";
  src = fetchurl {
    url = "https://github.com/zaproxy/zaproxy/releases/download/v${version}/ZAP_${version}_Linux.tar.gz";
    sha256 = "sha256-nESTyZHLk0cGOGTSQ2o3lc87aXYGJeez20Ac00LT/FU=";
  };

  buildInputs = [ jre ];

  # From https://github.com/zaproxy/zaproxy/blob/master/zap/src/main/java/org/parosproxy/paros/Constant.java
  version_tag = "20012000";

  # Copying config and adding version tag before first use to avoid permission
  # issues if zap tries to copy config on it's own.
  installPhase = ''
    mkdir -p "$out/bin" "$out/share"
    cp -pR . "$out/share/${pname}/"

    cat >> "$out/bin/${pname}" << EOF
    #!${runtimeShell}
    export PATH="${lib.makeBinPath [ jre ]}:\$PATH"
    export JAVA_HOME='${jre}'
    if ! [ -f "\$HOME/.ZAP/config.xml" ];then
      mkdir -p "\$HOME/.ZAP"
      head -n 2 $out/share/${pname}/xml/config.xml > "\$HOME/.ZAP/config.xml"
      echo "<version>${version_tag}</version>" >> "\$HOME/.ZAP/config.xml"
      tail -n +3 $out/share/${pname}/xml/config.xml >> "\$HOME/.ZAP/config.xml"
    fi
    exec "$out/share/${pname}/zap.sh"  "\$@"
    EOF

    chmod u+x  "$out/bin/${pname}"
  '';

  meta = with lib; {
    homepage = "https://www.owasp.org/index.php/ZAP";
    description = "Java application for web penetration testing";
    maintainers = with maintainers; [ mog rafael ];
    platforms = platforms.linux;
    license = licenses.asl20;
  };
}
