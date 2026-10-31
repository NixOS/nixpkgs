{
  lib,
  stdenv,
  fetchzip,
  unzip,
  testers,
  chromedriver,
}:

let
  upstream-info =
    (lib.importJSON ../../../../applications/networking/browsers/chromium/info.json)
    .chromium.chromedriver;

  inherit (upstream-info) version;
in
stdenv.mkDerivation {
  pname = "chromedriver";
  inherit version;

  src = fetchzip {
    url = "https://storage.googleapis.com/chrome-for-testing-public/${version}/mac-arm64/chromedriver-mac-arm64.zip";
    hash = upstream-info.hash_darwin_aarch64;
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    install -m555 -D "chromedriver" $out/bin/chromedriver
  '';

  passthru.tests.version = testers.testVersion { package = chromedriver; };

  meta = {
    homepage = "https://chromedriver.chromium.org/";
    description = "WebDriver server for running Selenium tests on Chrome";
    longDescription = ''
      WebDriver is an open source tool for automated testing of webapps across
      many browsers. It provides capabilities for navigating to web pages, user
      input, JavaScript execution, and more. ChromeDriver is a standalone
      server that implements the W3C WebDriver standard.
    '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsd3;
    maintainers = [ ];
    # Note from primeos: By updating Chromium I also update Google Chrome and
    # ChromeDriver.
    platforms = lib.platforms.darwin;
    mainProgram = "chromedriver";
  };
}
