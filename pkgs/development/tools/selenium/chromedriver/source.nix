{
  chromium,
  testers,
  chromedriver,
}:
chromium.mkDerivation (_: {
  name = "chromedriver";
  packageName = "chromedriver";

  # Build the unstripped target, because stripping in Chromium relies on a prebuilt strip binary
  # that doesn't run on NixOS, and we will strip everything ourselves later anyway.
  buildTargets = [ "chromedriver.unstripped" ];

  installPhase = ''
    install -Dm555 $buildPath/chromedriver.unstripped $out/bin/chromedriver
  '';

  # Kill existing postFixup that tries to patchelf things
  postFixup = null;

  passthru.tests.version = testers.testVersion { package = chromedriver; };

  meta = chromium.meta // {
    homepage = "https://chromedriver.chromium.org/";
    description = "WebDriver server for running Selenium tests on Chrome";
    longDescription = ''
      WebDriver is an open source tool for automated testing of webapps across
      many browsers. It provides capabilities for navigating to web pages, user
      input, JavaScript execution, and more. ChromeDriver is a standalone
      server that implements the W3C WebDriver standard.
    '';
    mainProgram = "chromedriver";
  };
})
