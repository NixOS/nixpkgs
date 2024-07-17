{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "htmlunit-driver-standalone";
  version = "2.27";

  src = fetchurl {
    url = "https://github.com/SeleniumHQ/htmlunit-driver/releases/download/${version}/htmlunit-driver-${version}-with-dependencies.jar";
    sha256 = "1sd3cwpamcbq9pv0mvcm8x6minqrlb4i0r12q3jg91girqswm2dp";
  };

  dontUnpack = true;

  installPhase = "install -D $src $out/share/lib/${pname}-${version}/${pname}-${version}.jar";

  meta = with lib; {
    homepage = "https://github.com/SeleniumHQ/htmlunit-driver";
    description = "A WebDriver server for running Selenium tests on the HtmlUnit headless browser";
    maintainers = with maintainers; [
      coconnor
      offline
    ];
    platforms = platforms.all;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
  };
}
