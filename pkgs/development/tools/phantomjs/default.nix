{ stdenv, lib, fetchurl, freetype, fontconfig, openssl, unzip }:

let
  platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
in

stdenv.mkDerivation rec {
  name = "phantomjs-1.9.8";

  # I chose to use the binary build for now.
  # The source version is quite nasty to compile
  # because it has bundled a lot of external libraries (like QT and Webkit)
  # and no easy/nice way to use the system versions of these

  src = if stdenv.hostPlatform.system == "i686-linux" then
          fetchurl {
            url = "https://bitbucket.org/ariya/phantomjs/downloads/${name}-linux-i686.tar.bz2";
            sha256 = "11fzmssz9pqf3arh4f36w06sl2nyz8l9h8iyxyd7w5aqnq5la0j1";
          }
        else
          if stdenv.hostPlatform.system == "x86_64-linux" then
            fetchurl {
              url = "https://bitbucket.org/ariya/phantomjs/downloads/${name}-linux-x86_64.tar.bz2";
              sha256 = "0fhnqxxsxhy125fmif1lwgnlhfx908spy7fx9mng4w72320n5nd1";
            }
          else # x86_64-darwin
            fetchurl {
              url = "https://bitbucket.org/ariya/phantomjs/downloads/${name}-macosx.zip";
              sha256 = "0j0aq8dgzmb210xdrh0v3d4nblskl3zsckl8bzf1a603wcx085cg";
            };

  buildInputs = lib.optional stdenv.isDarwin unzip;

  buildPhase = lib.optionalString (!stdenv.isDarwin) ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${stdenv.lib.makeLibraryPath [ freetype fontconfig stdenv.cc.cc stdenv.cc.cc openssl ]}" \
      bin/phantomjs
  '';

  dontPatchELF = true;
  dontStrip    = true;

  installPhase = ''
    mkdir -p $out/share/doc/phantomjs
    cp -a bin $out
    cp -a ChangeLog examples LICENSE.BSD README.md third-party.txt $out/share/doc/phantomjs
  '';

  meta = {
    description = "Headless WebKit with JavaScript API";
    longDescription = ''
      PhantomJS is a headless WebKit with JavaScript API.
      It has fast and native support for various web standards:
      DOM handling, CSS selector, JSON, Canvas, and SVG.

      PhantomJS is an optimal solution for:
      - Headless Website Testing
      - Screen Capture
      - Page Automation
      - Network Monitoring
    '';

    homepage = http://phantomjs.org/;
    license = lib.licenses.bsd3;

    maintainers = [ lib.maintainers.bluescreen303 ];
    inherit platforms;
  };
}
