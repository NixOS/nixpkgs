{ stdenv, fetchurl, makeWrapper, jre
, htmlunit-driver, chromedriver, chromeSupport ? true }:

with stdenv.lib;

let
  minorVersion = "3.6";
  patchVersion = "0";

in stdenv.mkDerivation rec {
  pname = "selenium-server-standalone";
  version = "${minorVersion}.${patchVersion}";

  src = fetchurl {
    url = "http://selenium-release.storage.googleapis.com/${minorVersion}/selenium-server-standalone-${version}.jar";
    sha256 = "11v340nm8vzqc2bkmbjfm9a7j4dj0bi9bfk8wdpfan0fb8prf772";
  };

  dontUnpack = true;

  buildInputs = [ jre makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/lib/${pname}-${version}
    cp $src $out/share/lib/${pname}-${version}/${pname}-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/selenium-server \
      --add-flags "-cp $out/share/lib/${pname}-${version}/${pname}-${version}.jar:${htmlunit-driver}/share/lib/${htmlunit-driver.name}/${htmlunit-driver.name}.jar" \
      --add-flags ${optionalString chromeSupport "-Dwebdriver.chrome.driver=${chromedriver}/bin/chromedriver"} \
      --add-flags "org.openqa.grid.selenium.GridLauncherV3"
  '';

  meta = {
    homepage = http://www.seleniumhq.org/;
    description = "Selenium Server for remote WebDriver";
    maintainers = with maintainers; [ coconnor offline ];
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
