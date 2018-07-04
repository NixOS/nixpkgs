{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "legends-browser-${version}";
  version = "1.17.1";

  src = fetchurl {
    url = "https://github.com/robertjanetzko/LegendsBrowser/releases/download/${version}/legendsbrowser-${version}.jar";
    sha256 = "05b4ksbl4481rh3ykfirbp6wvxhppcd5mvclhn9995gsrcaj8gx9";
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    ln -s $src $out/legends-browser.jar
    echo "${jre}/bin/java -jar $out/legends-browser.jar" > $out/bin/legends-browser
    chmod a+x $out/bin/legends-browser
  '';

  meta = with stdenv.lib; {
    description = "A multi-platform, open source, java-based legends viewer for dwarf fortress";
    maintainers = with maintainers; [ Baughn ];
    license = licenses.mit;
    platforms = platforms.all;
    homepage = https://github.com/robertjanetzko/LegendsBrowser;
  };
}
