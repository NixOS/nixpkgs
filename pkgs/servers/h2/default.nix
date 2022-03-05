{ lib, stdenv, fetchzip, jre, makeWrapper }:
stdenv.mkDerivation rec {
  pname = "h2";
  version = "2.1.210";

  src = fetchzip {
    url = "https://github.com/h2database/h2database/releases/download/version-${version}/h2-2022-01-17.zip";
    sha256 = "0zcjblhjj98dsj954ia3by9vx5w7mix1dzi85jnvp18kxmbldmf4";
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
    license = licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ mahe ];
  };
}
