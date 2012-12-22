{ stdenv, fetchurl, upx, freetype, fontconfig }:

assert stdenv.lib.elem stdenv.system [ "i686-linux" "x86_64-linux" ];

stdenv.mkDerivation rec {
  name = "phantomjs-1.7.0";

  # I chose to use the binary build for now.
  # The source version is quite nasty to compile
  # because it has bundled a lot of external libraries (like QT and Webkit)
  # and no easy/nice way to use the system versions of these

  src = if stdenv.system == "i686-linux" then
          fetchurl {
            url = "http://phantomjs.googlecode.com/files/${name}-linux-i686.tar.bz2";
            sha256 = "045d80lymjxnsssa0sgp5pgkahm651jk69ibk3mjczk3ykc1k91f";
          }
        else # x86_64-linux
          fetchurl {
            url = "http://phantomjs.googlecode.com/files/${name}-linux-x86_64.tar.bz2";
            sha256 = "1m14czhi3b388didn0a881glsx8bnsg9gnxgj5lghr4l5mgqyrd7";
          };

  buildNativeInputs = stdenv.lib.optional (stdenv.system == "x86_64-linux") upx;

  buildPhase = stdenv.lib.optionalString (stdenv.system == "x86_64-linux") ''
    upx -d bin/phantomjs
  '' + ''
    patchelf \
      --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath ${freetype}/lib:${fontconfig}/lib:${stdenv.gcc.gcc}/lib64:${stdenv.gcc.gcc}/lib \
      bin/phantomjs
  '';

  dontStrip = true;

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
    license = stdenv.lib.licenses.bsd3;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = ["i686-linux" "x86_64-linux" ];
  };
}
