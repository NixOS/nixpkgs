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
    (lib.importJSON ../../../../applications/networking/browsers/chromium/info.json).chromium;

  # See ./source.nix for Linux
  allSpecs = {
    x86_64-darwin = {
      system = "mac-x64";
      hash = upstream-info.chromedriver.hash_darwin;
    };

    aarch64-darwin = {
      system = "mac-arm64";
      hash = upstream-info.chromedriver.hash_darwin_aarch64;
    };
  };

  spec =
    allSpecs.${stdenv.hostPlatform.system}
      or (throw "missing chromedriver binary for ${stdenv.hostPlatform.system}");

  inherit (upstream-info) version;
in
stdenv.mkDerivation {
  pname = "chromedriver";
  inherit version;

  src = fetchzip {
    url = "https://storage.googleapis.com/chrome-for-testing-public/${version}/${spec.system}/chromedriver-${spec.system}.zip";
    inherit (spec) hash;
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    install -m555 -D "chromedriver" $out/bin/chromedriver
  '';

  passthru.tests.version = testers.testVersion { package = chromedriver; };

  meta = with lib; {
    homepage = "https://chromedriver.chromium.org/";
    description = "WebDriver server for running Selenium tests on Chrome";
    longDescription = ''
      WebDriver is an open source tool for automated testing of webapps across
      many browsers. It provides capabilities for navigating to web pages, user
      input, JavaScript execution, and more. ChromeDriver is a standalone
      server that implements the W3C WebDriver standard.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.bsd3;
    maintainers = with maintainers; [
      goibhniu
      primeos
    ];
    # Note from primeos: By updating Chromium I also update Google Chrome and
    # ChromeDriver.
    platforms = platforms.darwin;
    mainProgram = "chromedriver";
  };
}
