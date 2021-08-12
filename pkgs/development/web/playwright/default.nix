{ lib
, stdenv
, fetchurl
, unzip
, patchelf
, google-chrome-dev
, makeWrapper
}:

# Get rev from
# https://github.com/microsoft/playwright/blob/v1.13.1/browsers.json
let
  chromium-rev = "901522";
  firefox-rev = "1278";
in

stdenv.mkDerivation rec {
  version = "1.13.1";
  pname = "playwright";

  src = fetchurl {
    url = "https://playwright.azureedge.net/builds/chromium/${chromium-rev}/chromium-linux.zip";
    sha256 = "0q2jaf6nc8x3qq19x44dp0r9yg8f0i4k1z4hsqb4c693jm33krac";
  };

  nativeBuildInputs = [ patchelf makeWrapper unzip ];

  rpath = google-chrome-dev.rpath;
  binpath = google-chrome-dev.binpath;

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p $out/share/google/chrome
    cp -r * $out/share/google/chrome

    appname=chrome
    exe=$out/bin/chromium-playwright

    makeWrapper "$out/share/google/$appname/$appname" "$exe" \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --prefix PATH            : "$binpath"

    for elf in $out/share/google/$appname/{chrome,chrome_sandbox,crashpad_handler,nacl_helper}; do
      patchelf --set-rpath $rpath $elf
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $elf
    done
  '';

  meta = with lib; {
    description = "Node.js library to automate Chromium, Firefox and WebKit with a single API";
    homepage = "https://playwright.dev/";
    license = licenses.epl20;
    maintainers = [ maintainers.jlesquembre ];
    platforms = platforms.linux;
  };
}
