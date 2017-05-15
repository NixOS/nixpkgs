{ stdenv, fetchurl, cairo, fontconfig, freetype, gdk_pixbuf, glib
, glibc, gtk2, libX11, makeWrapper, nspr, nss, pango, unzip, gconf
, libXi, libXrender, libXext, lib
}:
let
  spec = if stdenv.system == "i686-linux" then { system="linux32"; sha256="5d267a8d59f18f1134966e312997b75976f8d816318b5b79b8357a3ac2c022da"; }
    else if stdenv.system == "x86_64-linux" then { system="linux64"; sha256="d011749e76305b5591b5500897939b33fac460d705d9815b8c03c53b0e1ecc7c"; }
    else if stdenv.system == "x86_64-darwin" then { system="mac64"; sha256="e95fb36ab85264e16c51d58dd9766624eca6b6339569da0460088f4c788c67ad"; }
    else abort "missing chromedriver binary for ${stdenv.system}";
in
stdenv.mkDerivation rec {
  name = "chromedriver-${version}";
  version = "2.25";

  src = fetchurl {
    url = "http://chromedriver.storage.googleapis.com/${version}/chromedriver_${spec.system}.zip";
    sha256 = spec.sha256;
  };

  buildInputs = [ unzip makeWrapper ];

  unpackPhase = "unzip $src";

  installPhase = ''
    mkdir -p $out/bin
    mv chromedriver $out/bin
    ${lib.optionalString (!stdenv.isDarwin) "patchelf --set-interpreter ${glibc.out}/lib/ld-linux-x86-64.so.2 $out/bin/chromedriver"}
    ${lib.optionalString (!stdenv.isDarwin) ''wrapProgram "$out/bin/chromedriver" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc.lib cairo fontconfig freetype gdk_pixbuf glib gtk2 libX11 nspr nss pango libXrender gconf libXext libXi ]}:\$LD_LIBRARY_PATH"''}
  '';

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/chromedriver/;
    description = "A WebDriver server for running Selenium tests on Chrome";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
