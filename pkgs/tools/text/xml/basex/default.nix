{ lib, stdenv, fetchurl, unzip, jre, coreutils, makeDesktopItem }:

stdenv.mkDerivation rec {
  pname = "basex";
  version = "9.4.3";

  src = fetchurl {
    url = "http://files.basex.org/releases/${version}/BaseX${builtins.replaceStrings ["."] [""] version}.zip";
    hash = "sha256-IZhRg2JcYQXQKU/lYZpLLcsSdjZZO+toY5yvk+RKUCY=";
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ jre ];

  desktopItem = makeDesktopItem {
    name = "basex";
    exec = "basexgui %f";
    icon = "${./basex.svg}"; # icon copied from Ubuntu basex package
    comment = "Visually query and analyse your XML data";
    desktopName = "BaseX XML Database";
    genericName = "XML database tool";
    categories = "Development;Utility;Database";
    mimeType = "text/xml";
  };

  dontBuild = true;

  installPhase = ''
    # Remove Windows batch files (unclutter $out/bin)
    rm ./bin/*.bat

    mkdir -p "$out/share/basex" "$out/share/applications"

    cp -R bin etc lib webapp src BaseX.jar "$out"
    cp -R readme.txt webapp "$out/share/basex"

    # Install desktop file
    cp "$desktopItem"/share/applications/* "$out/share/applications/"

    # Use substitutions instead of wrapper scripts
    for file in "$out"/bin/*; do
        sed -i -e "s|/usr/bin/env bash|${stdenv.shell}|" \
               -e "s|java|${jre}/bin/java|" \
               -e "s|readlink|${coreutils}/bin/readlink|" \
               -e "s|dirname|${coreutils}/bin/dirname|" \
               -e "s|basename|${coreutils}/bin/basename|" \
               -e "s|echo|${coreutils}/bin/echo|" \
            "$file"
    done
  '';

  meta = with lib; {
    description = "XML database and XPath/XQuery processor";
    longDescription = ''
      BaseX is a very fast and light-weight, yet powerful XML database and
      XPath/XQuery processor, including support for the latest W3C Full Text
      and Update Recommendations. It supports large XML instances and offers a
      highly interactive front-end (basexgui). Apart from two local standalone
      modes, BaseX offers a client/server architecture.
    '';
    homepage = "https://basex.org/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
