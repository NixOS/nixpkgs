{ stdenv, fetchurl }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "htmlunit-driver-standalone-${version}";
  version = "2.27";

  src = fetchurl {
    url = "https://github.com/SeleniumHQ/htmlunit-driver/releases/download/${version}/htmlunit-driver-${version}-with-dependencies.jar";
    sha256 = "1sd3cwpamcbq9pv0mvcm8x6minqrlb4i0r12q3jg91girqswm2dp";
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
