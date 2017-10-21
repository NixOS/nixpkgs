# To enable specific database drivers, override this derivation and pass the
# driver packages in the drivers argument (e.g. mysql_jdbc, postgresql_jdbc).
{ stdenv, fetchurl, makeDesktopItem, makeWrapper, unzip
, jre
, drivers ? []
}:
let
  version = "3.7.1";
in stdenv.mkDerivation rec {
  name = "squirrel-sql-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/squirrel-sql/1-stable/${version}-plainzip/squirrelsql-${version}-standard.zip";
    sha256 = "1v141ply57k5krwbnnmz4mbs9hs8rbys0bkjz69gvxlqjizyiq23";
  };

  buildInputs = [
    jre makeWrapper stdenv unzip
  ];

  unpackPhase = ''
    unzip ${src}
  '';

  buildPhase = ''
    cd squirrelsql-${version}-standard
    chmod +x squirrel-sql.sh
  '';

  installPhase = ''
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

    mkdir -p $out/share/icons/hicolor/32x32/apps
    ln -s $out/share/squirrel-sql/icons/acorn.png \
      $out/share/icons/hicolor/32x32/apps/squirrel-sql.png
    ln -s ${desktopItem}/share/applications $out/share
  '';

  desktopItem = makeDesktopItem {
    name = "squirrel-sql";
    exec = "squirrel-sql";
    comment = meta.description;
    desktopName = "SQuirreL SQL";
    genericName = "SQL Client";
    categories = "Development;";
    icon = "squirrel-sql";
  };

  meta = {
    description = "Universal SQL Client";
    homepage = http://squirrel-sql.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ khumba ];
  };
}
