{ stdenv, lib, fetchurl, buildEnv, makeWrapper
, xorg, alsaLib, dbus, glib, gtk2, atk, pango, freetype, fontconfig
, gdk-pixbuf, cairo, nss, nspr, gconf, expat, systemd, libcap
, libnotify}:
let
  bits = if stdenv.hostPlatform.system == "x86_64-linux" then "x64"
         else "ia32";

  nwEnv = buildEnv {
    name = "nwjs-env";
    paths = [
      xorg.libX11 xorg.libXrender glib gtk2 atk pango cairo gdk-pixbuf
      freetype fontconfig xorg.libXcomposite alsaLib xorg.libXdamage
      xorg.libXext xorg.libXfixes nss nspr gconf expat dbus
      xorg.libXtst xorg.libXi xorg.libXcursor xorg.libXrandr libcap
      libnotify
    ];

    extraOutputsToInstall = [ "lib" "out" ];
  };

in stdenv.mkDerivation rec {
  pname = "nwjs";
  version = "0.12.3";

  src = fetchurl {
    url = "https://dl.nwjs.io/v${version}/nwjs-v${version}-linux-${bits}.tar.gz";
    sha256 = if bits == "x64" then
      "1i5ipn5x188cx54pbbmjj1bz89vvcfx5z1c7pqy2xzglkyb2xsyg" else
      "117gx6yjbcya64yg2vybcfyp591sid209pg8a33k9afbsmgz684c";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/nwjs
    cp -R * $out/share/nwjs

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/nwjs/nw
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/share/nwjs/nwjc

    ln -s ${lib.getLib systemd}/lib/libudev.so $out/share/nwjs/libudev.so.0

    patchelf --set-rpath "${nwEnv}/lib:${nwEnv}/lib64:${lib.makeLibraryPath [ stdenv.cc.cc ]}:$out/share/nwjs" $out/share/nwjs/nw
    patchelf --set-rpath "${nwEnv}/lib:${nwEnv}/lib64:$out/share/nwjs" $out/share/nwjs/nwjc

    mkdir -p $out/bin
    ln -s $out/share/nwjs/nw $out/bin
    ln -s $out/share/nwjs/nwjc $out/bin
  '';

  nativeBuildInputs = [ makeWrapper ];

  meta = with lib; {
    description = "An app runtime based on Chromium and node.js";
    homepage = "https://nwjs.io/";
    platforms = ["i686-linux" "x86_64-linux"];
    maintainers = [ maintainers.offline ];
    license = licenses.bsd3;
  };
}
