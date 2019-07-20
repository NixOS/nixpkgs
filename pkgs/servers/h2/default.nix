{ stdenv, fetchzip, jre, makeWrapper }:
stdenv.mkDerivation rec {
  name = "h2-${version}";

  version = "1.4.193";

  src = fetchzip {
    url = "https://www.h2database.com/h2-2016-10-31.zip";
    sha256 = "1da1qcfwi5gvh68i6w6y0qpcqp3rbgakizagkajmjxk2ryc4b3z9";
  };

  buildInputs = [ makeWrapper ];

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
      mkdir -p $out
      cp -R * $out

      echo '${h2ToolScript}' > $out/bin/h2tool.sh

      substituteInPlace $out/bin/h2.sh --replace "java" "${jre}/bin/java"

      chmod +x $out/bin/*.sh
    '';

  meta = with stdenv.lib; {
    description = "The Java SQL database";
    homepage = http://www.h2database.com/html/main.html;
    license = licenses.mpl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with maintainers; [ mahe ];
  };
}
