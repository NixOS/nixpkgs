{
  name,
  revision,
  browserVersion ? "",
}:
let
  cftUrl =
    path:
    assert browserVersion != "";
    "https://cdn.playwright.dev/builds/cft/${browserVersion}/${path}";

  registryUrl =
    browser: archive:
    "https://cdn.playwright.dev/dbazure/download/playwright/builds/${browser}/${revision}/${archive}";

  mk = url: stripRoot: {
    inherit url stripRoot;
  };
in
{
  chromium = {
    x86_64-linux = mk (cftUrl "linux64/chrome-linux64.zip") true;
    aarch64-linux = mk (registryUrl "chromium" "chromium-linux-arm64.zip") true;
    x86_64-darwin = mk (cftUrl "mac-x64/chrome-mac-x64.zip") false;
    aarch64-darwin = mk (cftUrl "mac-arm64/chrome-mac-arm64.zip") false;
  };

  "chromium-headless-shell" = {
    x86_64-linux = mk (cftUrl "linux64/chrome-headless-shell-linux64.zip") false;
    aarch64-linux = mk (registryUrl "chromium" "chromium-headless-shell-linux-arm64.zip") false;
    x86_64-darwin = mk (cftUrl "mac-x64/chrome-headless-shell-mac-x64.zip") false;
    aarch64-darwin = mk (cftUrl "mac-arm64/chrome-headless-shell-mac-arm64.zip") false;
  };

  firefox = {
    x86_64-linux = mk (registryUrl "firefox" "firefox-ubuntu-24.04.zip") true;
    aarch64-linux = mk (registryUrl "firefox" "firefox-ubuntu-24.04-arm64.zip") true;
    x86_64-darwin = mk (registryUrl "firefox" "firefox-mac.zip") false;
    aarch64-darwin = mk (registryUrl "firefox" "firefox-mac-arm64.zip") false;
  };

  webkit = {
    x86_64-linux = mk (registryUrl "webkit" "webkit-ubuntu-24.04.zip") false;
    aarch64-linux = mk (registryUrl "webkit" "webkit-ubuntu-24.04-arm64.zip") false;
    x86_64-darwin = mk (registryUrl "webkit" "webkit-mac-15.zip") false;
    aarch64-darwin = mk (registryUrl "webkit" "webkit-mac-15-arm64.zip") false;
  };

  ffmpeg = {
    x86_64-linux = mk (registryUrl "ffmpeg" "ffmpeg-linux.zip") false;
    aarch64-linux = mk (registryUrl "ffmpeg" "ffmpeg-linux-arm64.zip") false;
    x86_64-darwin = mk (registryUrl "ffmpeg" "ffmpeg-mac.zip") false;
    aarch64-darwin = mk (registryUrl "ffmpeg" "ffmpeg-mac-arm64.zip") false;
  };
}
.${name}
