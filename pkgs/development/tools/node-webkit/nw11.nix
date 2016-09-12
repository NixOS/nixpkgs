{ stdenv, fetchurl, buildEnv, makeWrapper
, xorg, alsaLib, dbus, glib, gtk, atk, pango, freetype, fontconfig
, gdk_pixbuf, cairo, zlib, nss, nssTools, nspr, gconf, expat, systemd, libcap
, libnotify}:
let
  bits = if stdenv.system == "x86_64-linux" then "x64"
         else "ia32";

  nwEnv = buildEnv {
    name = "node-webkit-env";
    paths = [
      xorg.libX11 xorg.libXrender glib gtk atk pango cairo gdk_pixbuf
      freetype fontconfig xorg.libXcomposite alsaLib xorg.libXdamage
      xorg.libXext xorg.libXfixes nss nspr gconf expat dbus stdenv.cc
      xorg.libXtst xorg.libXi xorg.libXcursor xorg.libXrandr libcap
      libnotify
    ];
    
    extraOutputsToInstall = [ "lib" "out" ];
  };

in stdenv.mkDerivation rec {
  name = "node-webkit-${version}";
  version = "0.11.2";

  src = fetchurl {
    url = "http://dl.node-webkit.org/v${version}/node-webkit-v${version}-linux-${bits}.tar.gz";
    sha256 = if bits == "x64" then
      "1iby0yrnbk9xfcsfz59f6g00l6rxiyxvq78shs0c145ky7lknq5q" else
      "1hk3c9z3kwmqaj87vc5k1a7fv8jhkyqw1wjmsl3q5i50w880h398";
  };

  installPhase = ''
    mkdir -p $out/share/node-webkit
    cp -R * $out/share/node-webkit

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/node-webkit/nw
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/node-webkit/nwsnapshot

    ln -s ${systemd.lib}/lib/libudev.so $out/share/node-webkit/libudev.so.0

    patchelf --set-rpath "${nwEnv}/lib:${nwEnv}/lib64:$out/share/node-webkit" $out/share/node-webkit/nw
    patchelf --set-rpath "${nwEnv}/lib:${nwEnv}/lib64:$out/share/node-webkit" $out/share/node-webkit/nwsnapshot

    mkdir -p $out/bin
    ln -s $out/share/node-webkit/nw $out/bin
    ln -s $out/share/node-webkit/nwsnapshot $out/bin
  '';

  buildInputs = [ makeWrapper ];

  meta = with stdenv.lib; {
    description = "An app runtime based on Chromium and node.js";
    homepage = https://github.com/rogerwang/node-webkit;
    platforms = ["i686-linux" "x86_64-linux"];
    maintainers = [ maintainers.offline ];
    license = licenses.bsd3;
  };
}
