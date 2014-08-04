{ stdenv, fetchurl, buildEnv, makeWrapper
, xlibs, alsaLib, dbus, glib, gtk, atk, pango, freetype, fontconfig
, gdk_pixbuf, cairo, zlib, nss, nssTools, nspr, gconf, expat, udev}:
let
  bits = if stdenv.system == "x86_64-linux" then "x64"
         else "ia32";

  nwEnv = buildEnv {
    name = "node-webkit-env";
    paths = [
      xlibs.libX11 xlibs.libXrender glib gtk atk pango cairo gdk_pixbuf
      freetype fontconfig xlibs.libXcomposite alsaLib xlibs.libXdamage xlibs.libXext
      xlibs.libXfixes nss nspr gconf expat dbus udev stdenv.gcc.gcc
    ];
  };

in stdenv.mkDerivation rec {
  name = "node-webkit-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "https://s3.amazonaws.com/node-webkit/v${version}/node-webkit-v${version}-linux-${bits}.tar.gz";
    sha256 = if bits == "x64" then
      "04b9hgrxxnvrzyc7kmlabvrfbzj9d6lif7z69zgsbn3x25nxxd2n" else
      "0icwdl564sbx27124js1l4whfld0n6nbysdd522frzk1759dzgri";
  };

  patchPhase = ''
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" nw
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" nwsnapshot
  '';

  installPhase = let
    LD_LIBRARY_PATH = "${nwEnv}/lib:${nwEnv}/lib64:$out/share/node-webkit";
  in ''
    mkdir -p $out/bin
    mkdir -p $out/share/node-webkit
    cp -R * $out/share/node-webkit

    ln -s ${udev}/lib/libudev.so $out/share/node-webkit/libudev.so.0

    makeWrapper $out/share/node-webkit/nw $out/bin/nw --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}"
    makeWrapper $out/share/node-webkit/nwsnapshot $out/bin/nwsnapshot --prefix LD_LIBRARY_PATH : "${LD_LIBRARY_PATH}"
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
