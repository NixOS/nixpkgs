{ lib, stdenv, fetchzip, jre, makeWrapper }:
stdenv.mkDerivation rec {
  pname = "h2";
  version = "2.2.220";

  src = fetchzip {
    url = "https://github.com/h2database/h2database/releases/download/version-${version}/h2-2023-07-04.zip";
    hash = "sha256-nSOkCZuHcy0GR4SRjx524+MLqxJyO1PRkImPOFR1yts=";
  };

  outputs = [ "out" "doc" ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase =
    let
      h2ToolScript = ''
        #!/usr/bin/env bash
        dir=$(dirname "$0")

        if [ -n "$1" ]; then
          ${jre}/bin/java -cp "$dir/h2-${version}.jar:$H2DRIVERS:$CLASSPATH" $1 "''${@:2}"
        else
          echo "You have to provide the full java class path for the h2 tool you want to run. E.g. 'org.h2.tools.Server'"
        fi
      '';
    in ''
      mkdir -p $out $doc/share/doc/
      cp -R bin $out/
      cp -R docs $doc/share/doc/h2

      echo '${h2ToolScript}' > $out/bin/h2tool.sh

      substituteInPlace $out/bin/h2.sh --replace "java" "${jre}/bin/java"

      chmod +x $out/bin/*.sh
    '';

  meta = with lib; {
    description = "The Java SQL database";
    homepage = "http://www.h2database.com/html/main.html";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ mahe ];
  };
}
