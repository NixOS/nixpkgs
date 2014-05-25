{ stdenv, fetchurl, unzip, jre, coreutils, makeDesktopItem }:

stdenv.mkDerivation rec {
  name = "basex-7.8.2";

  src = fetchurl {
    url = "http://files.basex.org/releases/7.8.2/BaseX782.zip";
    sha256 = "0i9h7fsvn8cy1g44f23iyqndwamvx4kvyc4y3i00j15qm6qd2kbm";
  };

  buildInputs = [ unzip jre ];

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

  # We're using a pre-built package
  configurePhase = "true";
  buildPhase = "true";
  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"

    # Remove Windows batch files (unclutter $out/bin)
    rm -f "$out"/bin/*.bat

    # Move some top-level stuff to $out/share/basex (unclutter $out)
    mkdir -p "$out/share/basex"
    mv "$out"/*.txt "$out/share/basex/"
    mv "$out"/webapp "$out/share/basex/"

    # Remove empty directories
    rmdir "$out/repo"
    rmdir "$out/data"

    # Install desktop file
    mkdir -p "$out/share/applications"
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

  meta = with stdenv.lib; {
    description = "XML database and XPath/XQuery processor";
    longDescription = ''
      BaseX is a very fast and light-weight, yet powerful XML database and
      XPath/XQuery processor, including support for the latest W3C Full Text
      and Update Recommendations. It supports large XML instances and offers a
      highly interactive front-end (basexgui). Apart from two local standalone
      modes, BaseX offers a client/server architecture.
    '';
    homepage = http://basex.org/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
