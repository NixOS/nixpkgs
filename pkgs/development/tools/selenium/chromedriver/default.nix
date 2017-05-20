{ stdenv, fetchurl, cairo, fontconfig, freetype, gdk_pixbuf, glib
, glibc, gtk2, libX11, makeWrapper, nspr, nss, pango, unzip, gconf
, libXi, libXrender, libXext
}:
let
  allSpecs = {
    "i686-linux" = {
      system = "linux32";
      sha256 = "70845d81304c5f5f0b7f65274216e613e867e621676a09790c8aa8ef81ea9766";
    };

    "x86_64-linux" = {
      system = "linux64";
      sha256 = "bb2cf08f2c213f061d6fbca9658fc44a367c1ba7e40b3ee1e3ae437be0f901c2";
    };

    "x86_64-darwin" = {
      system = "mac64";
      sha256 = "6c30bba7693ec2d9af7cd9a54729e10aeae85c0953c816d9c4a40a1a72fd8be0";
    };
  };

  spec = allSpecs."${stdenv.system}"
    or (throw "missing chromedriver binary for ${stdenv.system}");
in
stdenv.mkDerivation rec {
  name = "chromedriver-${version}";
  version = "2.29";

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
