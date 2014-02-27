{ stdenv, fetchurl }:
let version = "2.39.0";
in stdenv.mkDerivation {
  name = "selenium-server-${version}";

  src = fetchurl {
    url = "https://selenium.googlecode.com/files/selenium-server-standalone-2.39.0.jar";
    sha256 = "11ixh5x5f9kia2va8wssd3n7y57dkv3snw6xvk85y4qhzg64b65f";
  };

  unpack = "";

  buildCommand = ''
    cp $src $out
  '';

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/selenium;
    description = "Selenium Server for remote WebDriver.";
    maintainers = [ maintainers.coconnor ];
  };
}
