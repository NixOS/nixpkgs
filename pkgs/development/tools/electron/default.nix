{ stdenv, fetchurl, buildEnv, makeDesktopItem, makeWrapper, zlib, glib, alsaLib
, dbus, gtk, atk, pango, freetype, fontconfig, libgnome_keyring3, gdk_pixbuf
, cairo, cups, expat, libgpgerror, nspr, gconf, nss, xorg, libcap, unzip
, systemd, libnotify
}:
let
  atomEnv = buildEnv {
    name = "env-atom";
    paths = [
      stdenv.cc.cc zlib glib dbus gtk atk pango freetype libgnome_keyring3
      fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gconf nss
      xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
      xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
      xorg.libXcursor libcap systemd libnotify
    ];
  };
in stdenv.mkDerivation rec {
  name = "electron-${version}";
  version = "0.36.2";

  src = fetchurl {
    url = "https://github.com/atom/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
    sha256 = "01d78j8dfrdygm1r141681b3bfz1f1xqg9vddz7j52z1mlfv9f1d";
    name = "${name}.zip";
  };

  buildInputs = [ atomEnv makeWrapper unzip ];

  phases = [ "installPhase" "fixupPhase" ];

  unpackCmd = "unzip";

  installPhase = ''
    mkdir -p $out/bin
    unzip -d $out/bin $src
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
    $out/bin/electron
    wrapProgram $out/bin/electron \
    --prefix "LD_LIBRARY_PATH" : "${atomEnv}/lib:${atomEnv}/lib64"
  '';

  meta = with stdenv.lib; {
    description = "Cross platform desktop application shell";
    homepage = https://github.com/atom/electron;
    license = licenses.mit;
    maintainers = [ maintainers.travisbhartwell ];
    platforms = [ "x86_64-linux" ];
  };
}
