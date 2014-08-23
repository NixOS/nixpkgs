{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "selenium-server-standalone-${version}";
  version = "2.39.0";

  src = fetchurl {
    url = "https://selenium.googlecode.com/files/${name}.jar";
    sha256 = "11ixh5x5f9kia2va8wssd3n7y57dkv3snw6xvk85y4qhzg64b65f";
  };

  unpack = "";

  buildCommand = ''
    mkdir -p $out/share/lib/${name}
    cp $src $out/share/lib/${name}/${name}.jar
  '';

  meta = with stdenv.lib; {
    homepage = https://code.google.com/p/selenium;
    description = "Selenium Server for remote WebDriver.";
    maintainers = [ maintainers.coconnor ];
    platforms = platforms.all;
    hydraPlatforms = [];
    license = licenses.asl20;
  };
}
