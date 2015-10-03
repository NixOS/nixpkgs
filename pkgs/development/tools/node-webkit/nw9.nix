{ stdenv, fetchurl, buildEnv, makeWrapper
, xorg, alsaLib, dbus, glib, gtk, atk, pango, freetype, fontconfig
, gdk_pixbuf, cairo, zlib, nss, nssTools, nspr, gconf, expat, libudev }:
let
  bits = if stdenv.system == "x86_64-linux" then "x64"
         else "ia32";

  nwEnv = buildEnv {
    name = "node-webkit-env";
    paths = [
      xorg.libX11 xorg.libXrender glib gtk atk pango cairo gdk_pixbuf
      freetype fontconfig xorg.libXcomposite alsaLib xorg.libXdamage
      xorg.libXext xorg.libXfixes nss nspr gconf expat dbus stdenv.cc.cc
      xorg.libXtst xorg.libXi
    ];
  };

in stdenv.mkDerivation rec {
  name = "node-webkit-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "http://dl.node-webkit.org/v${version}/node-webkit-v${version}-linux-${bits}.tar.gz";
    sha256 = if bits == "x64" then
      "04b9hgrxxnvrzyc7kmlabvrfbzj9d6lif7z69zgsbn3x25nxxd2n" else
      "0icwdl564sbx27124js1l4whfld0n6nbysdd522frzk1759dzgri";
  };

  installPhase = ''
    mkdir -p $out/share/node-webkit
    cp -R * $out/share/node-webkit

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/node-webkit/nw
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/node-webkit/nwsnapshot

    ln -s ${libudev.out}/lib/libudev.so $out/share/node-webkit/libudev.so.0

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
