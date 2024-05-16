{ lib, stdenv, fetchurl, unzip, makeWrapper
, cairo, fontconfig, freetype, gdk-pixbuf, glib
, glibc, gtk2, libX11, nspr, nss, pango
, libxcb, libXi, libXrender, libXext, dbus
, testers, chromedriver
}:

let
  upstream-info = (import ../../../../applications/networking/browsers/chromium/upstream-info.nix).stable.chromedriver;
  allSpecs = {
    x86_64-linux = {
      system = "linux64";
      hash = upstream-info.hash_linux;
    };

    x86_64-darwin = {
      system = "mac-x64";
      hash = upstream-info.hash_darwin;
    };

    aarch64-darwin = {
      system = "mac-arm64";
      hash = upstream-info.hash_darwin_aarch64;
    };
  };

  spec = allSpecs.${stdenv.hostPlatform.system}
    or (throw "missing chromedriver binary for ${stdenv.hostPlatform.system}");

  libs = lib.makeLibraryPath [
    stdenv.cc.cc.lib
    cairo fontconfig freetype
    gdk-pixbuf glib gtk2
    libX11 nspr nss pango libXrender
    libxcb libXext libXi
    dbus
  ];

in stdenv.mkDerivation rec {
  pname = "chromedriver";
  version = upstream-info.version;

  src = fetchurl {
    url = "https://storage.googleapis.com/chrome-for-testing-public/${version}/${spec.system}/chromedriver-${spec.system}.zip";
    hash = spec.hash;
  };

  nativeBuildInputs = [ unzip makeWrapper ];

  unpackPhase = "unzip $src";

  installPhase = ''
    install -m755 -D "chromedriver-${spec.system}/chromedriver" $out/bin/chromedriver
  '' + lib.optionalString (!stdenv.isDarwin) ''
    patchelf --set-interpreter ${glibc.out}/lib/ld-linux-x86-64.so.2 $out/bin/chromedriver
    wrapProgram "$out/bin/chromedriver" --prefix LD_LIBRARY_PATH : "${libs}"
  '';

  passthru.tests.version = testers.testVersion { package = chromedriver; };

  meta = with lib; {
    homepage = "https://chromedriver.chromium.org/";
    description = "A WebDriver server for running Selenium tests on Chrome";
    longDescription = ''
      WebDriver is an open source tool for automated testing of webapps across
      many browsers. It provides capabilities for navigating to web pages, user
      input, JavaScript execution, and more. ChromeDriver is a standalone
      server that implements the W3C WebDriver standard.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu primeos ];
    # Note from primeos: By updating Chromium I also update Google Chrome and
    # ChromeDriver.
    platforms = attrNames allSpecs;
    mainProgram = "chromedriver";
  };
}
