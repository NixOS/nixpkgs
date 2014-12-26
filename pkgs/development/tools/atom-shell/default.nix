{ stdenv, fetchurl, buildEnv, makeDesktopItem, makeWrapper, zlib, glib, alsaLib
, dbus, gtk, atk, pango, freetype, fontconfig, libgnome_keyring3, gdk_pixbuf
, cairo, cups, expat, libgpgerror, nspr, gconf, nss, xlibs, libcap, unzip
}:
let
  atomEnv = buildEnv {
    name = "env-atom";
    paths = [
      stdenv.cc.gcc zlib glib dbus gtk atk pango freetype libgnome_keyring3
      fontconfig gdk_pixbuf cairo cups expat libgpgerror alsaLib nspr gconf nss
      xlibs.libXrender xlibs.libX11 xlibs.libXext xlibs.libXdamage xlibs.libXtst
      xlibs.libXcomposite xlibs.libXi xlibs.libXfixes xlibs.libXrandr
      xlibs.libXcursor libcap
    ];
  };
in stdenv.mkDerivation rec {
  name = "atom-shell-${version}";
  version = "0.19.1";

  src = fetchurl {
    url = "https://github.com/atom/atom-shell/releases/download/v0.19.1/atom-shell-v0.19.1-linux-x64.zip";
    sha256 = "10q1slwv2lkiqqxpv0m5a1k0gj2yp8bi9a7ilb05zz1wg7j3yw4y";
    name = "${name}.zip";
  };

  buildInputs = [ atomEnv makeWrapper unzip ];

  phases = [ "installPhase" "fixupPhase" ];

  unpackCmd = "unzip";

  installPhase = ''
    mkdir -p $out/bin
    unzip -d $out/bin $src
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
    $out/bin/atom
    mv $out/bin/atom $out/bin/atom-shell
    wrapProgram $out/bin/atom-shell \
    --prefix "LD_LIBRARY_PATH" : "${atomEnv}/lib:${atomEnv}/lib64"
  '';

  meta = with stdenv.lib; {
    description = "Cross platform desktop application shell";
    homepage = https://github.com/atom/atom-shell;
    license = [ licenses.mit ];
    maintainers = [ maintainers.fluffynukeit ];
    platforms = [ "x86_64-linux" ];
  };
}
