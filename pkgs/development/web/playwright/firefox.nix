{ lib
, stdenv
, fetchzip
, firefox-bin
, suffix
, revision
, system
, throwSystem
}:
let
  suffix' = if lib.hasPrefix "linux" suffix
            then "ubuntu-22.04" + (lib.removePrefix "linux" suffix)
            else suffix;
in
stdenv.mkDerivation {
  name = "firefox";
  src = fetchzip {
    url = "https://playwright.azureedge.net/builds/firefox/${revision}/firefox-${suffix'}.zip";
    sha256 = {
      x86_64-linux = "0jv6vpxbbl2hr0wcvsy8p3vrrxgmixyjn2iiwvc8ffpcpzvk529v";
      aarch64-linux = "0ygwx86bsrrjn0dfr4dbvpsc07h8hmy34llycn9rfm08iiwiwhw7";
    }.${system} or throwSystem;
  };

  inherit (firefox-bin.unwrapped)
    nativeBuildInputs
    buildInputs
    runtimeDependencies
    appendRunpaths
    patchelfFlags
  ;

  buildPhase = ''
    mkdir -p $out/firefox
    cp -R . $out/firefox
  '';
}
