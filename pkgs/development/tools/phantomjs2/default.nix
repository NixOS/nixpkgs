{ stdenv, fetchurl,
  bison2, flex, fontconfig, freetype, gperf, icu, openssl, libjpeg, libpng, perl, python, ruby, sqlite
}:

stdenv.mkDerivation rec {
  name = "phantomjs-${version}";
  version = "2.0.0-20150528";

  src = fetchurl {
    url = "https://github.com/bprodoehl/phantomjs/archive/v2.0.0-20150528.tar.gz";
    sha256 = "18h37bxxg25lacry9k3vb5yim057bqcxmsifw97jrjp7gzfx56v5";
  };

  buildInputs = [ bison2 flex fontconfig freetype gperf icu openssl libjpeg libpng perl python ruby sqlite ];

  patchPhase = ''
    patchShebangs .
    sed -i -e 's|/bin/pwd|pwd|' src/qt/qtbase/configure 
  '';

  buildPhase = "./build.sh --confirm";

  installPhase = ''
    mkdir -p $out/share/doc/phantomjs
    cp -a bin $out
    cp -a ChangeLog examples LICENSE.BSD README.md third-party.txt $out/share/doc/phantomjs
  '';

  meta = {
    description = "Headless WebKit with JavaScript API";
    longDescription = ''
      PhantomJS2 is a headless WebKit with JavaScript API.
      It has fast and native support for various web standards:
      DOM handling, CSS selector, JSON, Canvas, and SVG.

      PhantomJS is an optimal solution for:
      - Headless Website Testing
      - Screen Capture
      - Page Automation
      - Network Monitoring
    '';

    homepage = http://phantomjs.org/;
    license = stdenv.lib.licenses.bsd3;

    maintainers = [ stdenv.lib.maintainers.aflatter ];
    platforms = with stdenv.lib.platforms; darwin ++ linux;
  };
}
