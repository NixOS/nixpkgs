{ lib, fetchFromGitHub, python3, stdenvNoCC, zip, }:
let
  common = rec {
    version = "1.33.2";
    srcs = [
      (fetchFromGitHub {
        owner = "gorhill";
        repo = "uBlock";
        rev = version;
        sha256 = "1pdf3fzc7ld65gr87s1cdy2sb84jbqnyq9lvwg1mgzi9dg8x7639";
        name = "uBlock";
      })
      (fetchFromGitHub {
        owner = "uBlockOrigin";
        repo = "uAssets";
        rev = "98930aedf0a33b35ca65df71f99c5343a39d368c";
        sha256 = "1r0hh930ncslzcfk8l4hfdwhbn0yll0gy4jjwywjndnl8w54fkqv";
        name = "uAssets";
      })
    ];
    sourceRoot = "uBlock";
    nativeBuildInputs = [ python3 zip ];
    meta = with lib; {
      description = "uBlock Origin - An efficient blocker for Chromium and Firefox. Fast and lean.";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ chkno ];
    };
  };
  longDescription = ''
    uBlock Origin is NOT an "ad blocker": it is a wide-spectrum blocker -- which
    happens to be able to function as a mere "ad blocker". The default behavior
    of uBlock Origin when newly installed is to block ads, trackers and malware
    sites -- through EasyList, EasyPrivacy, Peter Lowe’s ad/tracking/malware
    servers, Online Malicious URL Blocklist, and uBlock Origin's own filter lists.
  '';
in {
  ublock-origin-chromium = stdenvNoCC.mkDerivation (lib.recursiveUpdate common {
    pname = "ublock-origin-chromium";
    buildPhase = ''
      patchShebangs ./tools/make-chromium.sh
      ./tools/make-chromium.sh
    '';
    installPhase = "cp -a dist/build/uBlock0.chromium $out";
    meta.longDescription = longDescription + ''

      To load into chromium:
        1. Go to chrome://extensions
        2. Enable Developer Mode by clicking the toggle switch next to Developer mode.
        3. Click the LOAD UNPACKED button and select the extension directory.
      as described in https://developer.chrome.com/docs/extensions/mv2/getstarted/#manifest
    '';
  });
  ublock-origin-firefox = stdenvNoCC.mkDerivation (lib.recursiveUpdate common {
    pname = "ublock-origin-firefox";
    buildPhase = ''
      patchShebangs ./tools/make-firefox.sh
      ./tools/make-firefox.sh all
    '';
    installPhase = ''
      mkdir $out
      cp dist/build/uBlock0.firefox.xpi $out
    '';
    meta.longDescription = longDescription + ''

      This build produces an unsigned extension.  See
      https://support.mozilla.org/en-US/kb/add-on-signing-in-firefox
      for info about how to use unsigned extensions with Firefox.
    '';
  });
}
