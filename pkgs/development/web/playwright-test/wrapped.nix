{ lib
, callPackage
, buildNpmPackage
, fetchurl
, python3
, playwright-driver
, makeWrapper
}:
let
  driver = playwright-driver;
  browsers = playwright-driver.browsers;


  # nodeDependencies / package / shell
  playwright-test-raw = (callPackage ./default.nix { })."@playwright/test-${driver.version}";

  /*
  playwright-test usually installs patched browsers from their servers in a versioned folder
  such as ~/.cache/ms-playwright/chromium-{browser_revision}
  playwright-browsers contain the (potentially patched) browsers as expected by playwright, we tell
  them plawyright-test how to find them via PLAYWRIGHT_BROWSERS_PATH
  */
  playwright-test = playwright-test-raw.overrideAttrs (oa: {
    nativeBuildInputs = oa.nativeBuildInputs or [ ] ++ [
      makeWrapper
    ];
    postInstall = ''
      # you need to set both the path and version else playwright looks into the wrong one
      wrapProgram $out/bin/playwright \
          --set-default PLAYWRIGHT_BROWSERS_PATH "${browsers}" \
          --prefix NODE_PATH : ${placeholder "out"}/lib/node_modules
    '';
  });
in
  playwright-test
