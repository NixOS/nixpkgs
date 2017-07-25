{ stdenv, fetchurl, cairo, fontconfig, freetype, gdk_pixbuf, glib
, glibc, gtk2, libX11, makeWrapper, nspr, nss, pango, unzip, gconf
, libXi, libXrender, libXext
}:
let
  allSpecs = {
    "i686-linux" = {
      system = "linux32";
      sha256 = "1qi49rcm7r4b8yqx4akmirilp4ifip89n7inji0pihdqzaw604d4";
    };

    "x86_64-linux" = {
      system = "linux64";
      sha256 = "1845nh7kj8scgn85yqwp4nsx7fabcb09w23jp8xa1cxyfvv2wdry";
    };

    "x86_64-darwin" = {
      system = "mac64";
      sha256 = "0zyv8i4dbzyk58g4hr5143akgsfaaq9659bwj1m41jwi965grcxa";
    };
  };

  spec = allSpecs."${stdenv.system}"
    or (throw "missing chromedriver binary for ${stdenv.system}");
in
stdenv.mkDerivation rec {
  name = "chromedriver-${version}";
  version = "2.31";

  src = fetchurl {
    url = "http://chromedriver.storage.googleapis.com/${version}/chromedriver_${spec.system}.zip";
    sha256 = spec.sha256;
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = "unzip $src";

  libs = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc.lib
    cairo fontconfig freetype
    gdk_pixbuf glib gtk2 gconf
    libX11 nspr nss pango libXrender
    gconf libXext libXi
  ];

  installPhase = ''
    install -m755 -D chromedriver $out/bin/chromedriver
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    patchelf --set-interpreter ${glibc.out}/lib/ld-linux-x86-64.so.2 $out/bin/chromedriver
    wrapProgram "$out/bin/chromedriver" --prefix LD_LIBRARY_PATH : "${libs}:\$LD_LIBRARY_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/chromedriver/;
    description = "A WebDriver server for running Selenium tests on Chrome";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = attrNames allSpecs;
  };
}
