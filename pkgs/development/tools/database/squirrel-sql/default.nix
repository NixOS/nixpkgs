# To enable specific database drivers, override this derivation and pass the
# driver packages in the drivers argument (e.g. mysql_jdbc, postgresql_jdbc).
{ lib, stdenv, fetchurl, makeDesktopItem, makeWrapper, unzip
, jre
, drivers ? []
}:
stdenv.mkDerivation rec {
  pname = "squirrel-sql";
  version = "4.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/squirrel-sql/1-stable/${version}-plainzip/squirrelsql-${version}-standard.zip";
    sha256 = "sha256-uMOVhLqjZB21SAvNXT6VhdmFyCFhBYHID9lXeDABvnk=";
  };

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ jre ];

  unpackPhase = ''
    runHook preUnpack
    unzip ${src}
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild
    cd squirrelsql-${version}-standard
    chmod +x squirrel-sql.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/squirrel-sql
    cp -r . $out/share/squirrel-sql

    mkdir -p $out/bin
    cp=""
    for pkg in ${builtins.concatStringsSep " " drivers}; do
      if test -n "$cp"; then
        cp="$cp:"
      fi
      cp="$cp"$(echo $pkg/share/java/*.jar | tr ' ' :)
    done
    makeWrapper $out/share/squirrel-sql/squirrel-sql.sh $out/bin/squirrel-sql \
      --set CLASSPATH "$cp" \
      --set JAVA_HOME "${jre}"
    # Make sure above `CLASSPATH` gets picked up
    substituteInPlace $out/share/squirrel-sql/squirrel-sql.sh --replace "-cp \"\$CP\"" "-cp \"\$CLASSPATH:\$CP\""

    mkdir -p $out/share/icons/hicolor/32x32/apps
    ln -s $out/share/squirrel-sql/icons/acorn.png \
      $out/share/icons/hicolor/32x32/apps/squirrel-sql.png
    ln -s ${desktopItem}/share/applications $out/share

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = "squirrel-sql";
    exec = "squirrel-sql";
    comment = meta.description;
    desktopName = "SQuirreL SQL";
    genericName = "SQL Client";
    categories = [ "Development" ];
    icon = "squirrel-sql";
  };

  meta = with lib; {
    description = "Universal SQL Client";
    homepage = "http://squirrel-sql.sourceforge.net/";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ khumba ];
  };
}
