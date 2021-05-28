{ stdenv, fetchurl, cairo, fontconfig, freetype, gdk-pixbuf, glib
, glibc, gtk2, libX11, makeWrapper, nspr, nss, pango, unzip, gconf
, libxcb, libXi, libXrender, libXext
}:
let
  allSpecs = {
    x86_64-linux = {
      system = "linux64";
      sha256 = "0absr1fp2h87gpyw6jxj2f08sbhkkh3pf13145hfyzdvajj5rfjy";
    };

    x86_64-darwin = {
      system = "mac64";
      sha256 = "1p9k92fgyx0xis6r50vhcpx3iws2gaspq3dnpigglv3bj9yg8zvi";
    };
  };

  spec = allSpecs.${stdenv.hostPlatform.system}
    or (throw "missing chromedriver binary for ${stdenv.hostPlatform.system}");

  libs = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc.lib
    cairo fontconfig freetype
    gdk-pixbuf glib gtk2 gconf
    libX11 nspr nss pango libXrender
    gconf libxcb libXext libXi
  ];
in
stdenv.mkDerivation rec {
  pname = "chromedriver";
  version = "85.0.4183.87";

  src = fetchurl {
    url = "https://chromedriver.storage.googleapis.com/${version}/chromedriver_${spec.system}.zip";
    sha256 = spec.sha256;
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = "unzip $src";

  installPhase = ''
    install -m755 -D chromedriver $out/bin/chromedriver
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    patchelf --set-interpreter ${glibc.out}/lib/ld-linux-x86-64.so.2 $out/bin/chromedriver
    wrapProgram "$out/bin/chromedriver" --prefix LD_LIBRARY_PATH : "${libs}:\$LD_LIBRARY_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = "https://sites.google.com/a/chromium.org/chromedriver";
    description = "A WebDriver server for running Selenium tests on Chrome";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu maintainers.marsam ];
    platforms = attrNames allSpecs;
  };
}
