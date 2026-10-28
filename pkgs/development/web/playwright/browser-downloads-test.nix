{
  lib,
  runCommand,
  nodejs,
  playwright-core,
}:
let
  browserNames = [
    "chromium"
    "chromium-headless-shell"
    "firefox"
    "webkit"
    "ffmpeg"
  ];
  browsersJSON = (lib.importJSON ./browsers.json).browsers;
  browserDownloads = lib.genAttrs browserNames (
    name:
    import ./browser-downloads.nix {
      inherit name;
      inherit (browsersJSON.${name}) revision;
      browserVersion = browsersJSON.${name}.browserVersion or "";
    }
  );
  browserDownloadsExpectedJSON = builtins.toFile "playwright-browser-downloads.json" (
    builtins.toJSON browserDownloads
  );
in
runCommand "playwright-browser-downloads-test"
  {
    nativeBuildInputs = [ nodejs ];
  }
  ''
    node ${./browser-downloads-test.js} ${playwright-core} ${browserDownloadsExpectedJSON}
    touch $out
  ''
