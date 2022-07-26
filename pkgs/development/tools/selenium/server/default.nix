{ lib, stdenv, fetchurl, makeWrapper, jre
, htmlunit-driver, chromedriver, chromeSupport ? true }:

with lib;

let
  minorVersion = "3.141";
  patchVersion = "59";

in stdenv.mkDerivation rec {
  pname = "selenium-server-standalone";
  version = "${minorVersion}.${patchVersion}";

  src = fetchurl {
    url = "http://selenium-release.storage.googleapis.com/${minorVersion}/selenium-server-standalone-${version}.jar";
    sha256 = "1jzkx0ahsb27zzzfvjqv660x9fz2pbcddgmhdzdmasxns5vipxxc";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    mkdir -p $out/share/lib/${pname}-${version}
    cp $src $out/share/lib/${pname}-${version}/${pname}-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/selenium-server \
      --add-flags "-cp $out/share/lib/${pname}-${version}/${pname}-${version}.jar:${htmlunit-driver}/share/lib/${htmlunit-driver.name}/${htmlunit-driver.name}.jar" \
      ${optionalString chromeSupport "--add-flags -Dwebdriver.chrome.driver=${chromedriver}/bin/chromedriver"} \
      --add-flags "org.openqa.grid.selenium.GridLauncherV3"
  '';

  meta = {
    homepage = "http://www.seleniumhq.org/";
    description = "Selenium Server for remote WebDriver";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ coconnor offline ];
    mainProgram = "selenium-server";
    platforms = platforms.all;
  };
}
