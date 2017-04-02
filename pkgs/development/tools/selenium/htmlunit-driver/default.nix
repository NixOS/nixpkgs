{ stdenv, fetchurl }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "htmlunit-driver-standalone-${version}";
  version = "2.21";

  src = fetchurl {
    url = "https://github.com/SeleniumHQ/htmlunit-driver/releases/download/${version}/htmlunit-driver-standalone-${version}.jar";
    sha256 = "1wrbam0hb036717z3y73lsw4pwp5sdiw2i1818kg9pvc7i3fb3yn";
  };

  unpackPhase = "true";

  installPhase = "install -D $src $out/share/lib/${name}/${name}.jar";

  meta = {
    homepage = https://github.com/SeleniumHQ/htmlunit-driver;
    description = "A WebDriver server for running Selenium tests on the HtmlUnit headless browser";
    maintainers = with maintainers; [ coconnor offline ];
    platforms = platforms.all;
    license = licenses.asl20;
  };
}
