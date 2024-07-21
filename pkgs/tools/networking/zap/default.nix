{ lib, stdenv, fetchurl, jre, undmg, runtimeShell }:

let
  pname = "zap";
  version = "2.15.0";
  sources = {
    linux = fetchurl {
      url =
        "https://github.com/zaproxy/zaproxy/releases/download/v${version}/ZAP_${version}_Linux.tar.gz";
      sha256 = "sha256-ZBDhlrqrRYqSBOKar7V0X8oAOipsA4byxuXAS2diH6c=";
    };
    darwin-x86_64 = fetchurl {
      url =
        "https://github.com/zaproxy/zaproxy/releases/download/v${version}/ZAP_${version}.dmg";
      sha256 = "sha256-rgJUA+Rs3v/wE80MO4jY7cWhg6dtqmPLYsfGKQBTN6U=";
    };
    darwin-aarch64 = fetchurl {
      url =
        "https://github.com/zaproxy/zaproxy/releases/download/v${version}/ZAP_${version}_aarch64.dmg";
      sha256 = "sha256-RCYlP0cCu9X7R3m89NYkkLLBDshRxOvJTO2PFW0uVQk=";
    };
  };

  meta = with lib; {
    homepage = "https://www.zaproxy.org/";
    description = "Open-source web application security scanner";
    maintainers = with maintainers; [ mog rafael ];
    platforms = platforms.unix;
    license = licenses.asl20;
    mainProgram = "zap";
  };

  darwin = stdenv.mkDerivation {
    inherit pname version meta;

    src = if stdenv.isAarch64 then
      sources.darwin-aarch64
    else
      sources.darwin-x86_64;

    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications/
      cp -a ZAP.app $out/Applications/
    '';
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = sources.linux;

    buildInputs = [ jre ];

    # From https://github.com/zaproxy/zaproxy/blob/master/zap/src/main/java/org/parosproxy/paros/Constant.java
    version_tag = "20012000";

    # Copying config and adding version tag before first use to avoid permission
    # issues if zap tries to copy config on it's own.
    installPhase = ''
      mkdir -p $out/{bin,share}
      cp -pR . "$out/share/${pname}/"

      cat >> "$out/bin/${pname}" << EOF
      #!${runtimeShell}
      export PATH="${lib.makeBinPath [ jre ]}:\$PATH"
      export JAVA_HOME='${jre}'
      if [[ ! -f "$HOME/.ZAP/config.xml" ]]; then
        mkdir -p "\$HOME/.ZAP"
        head -n 2 $out/share/${pname}/xml/config.xml > "\$HOME/.ZAP/config.xml"
        echo "<version>${version_tag}</version>" >> "\$HOME/.ZAP/config.xml"
        tail -n +3 $out/share/${pname}/xml/config.xml >> "\$HOME/.ZAP/config.xml"
      fi
      exec "$out/share/${pname}/zap.sh"  "\$@"
      EOF

      chmod u+x  "$out/bin/${pname}"
    '';
  };
in if stdenv.isDarwin then darwin else linux
