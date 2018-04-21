{ stdenv, lib, fetchurl, makeWrapper, fakeroot, file, getopt
, gtk2, gdk_pixbuf, glib, libGLU, postgresql, nss, nspr, udev
, alsaLib, GConf, cups, libcap, fontconfig, freetype, pango
, cairo, dbus, expat, zlib, libpng12, nodejs, gnutar, gcc, gcc_32bit
, libX11, libXcursor, libXdamage, libXfixes, libXrender, libXi
, libXcomposite, libXext, libXrandr, libXtst, libSM, libICE, libxcb
, mono, libgnomeui, gnome_vfs, gnome-sharp, gtk-sharp-2_0, chromium
}:

let
  libPath64 = lib.makeLibraryPath [
    gcc.cc gtk2 gdk_pixbuf glib libGLU postgresql nss nspr
    alsaLib GConf cups libcap fontconfig freetype pango
    cairo dbus expat zlib libpng12 udev
    libX11 libXcursor libXdamage libXfixes libXrender libXi
    libXcomposite libXext libXrandr libXtst libSM libICE libxcb
  ];
  libPath32 = lib.makeLibraryPath [ gcc_32bit.cc ];
  binPath = lib.makeBinPath [ nodejs gnutar ];
  developBinPath = lib.makeBinPath [ mono ];
  developLibPath = lib.makeLibraryPath [
    glib libgnomeui gnome_vfs gnome-sharp gtk-sharp-2_0 gtk-sharp-2_0.gtk
  ];
  developDotnetPath = lib.concatStringsSep ":" [
    gnome-sharp gtk-sharp-2_0
  ];

  ver = "5.6.1";
  build = "f1";

in stdenv.mkDerivation rec {
  name = "unity-editor-${version}";
  version = "${ver}x${build}";

  src = fetchurl {
    url = "http://beta.unity3d.com/download/6a86e542cf5c/unity-editor-installer-${version}Linux.sh";
    sha256 = "10z4h94c9h967gx4b3gwb268zn7bnrb7ylnqnmnqhx6byac7cf4m";
  };

  nosuidLib = ./unity-nosuid.c;

  nativeBuildInputs = [ makeWrapper fakeroot file getopt ];

  outputs = [ "out" "monodevelop" ];

  sourceRoot = "unity-editor-${version}Linux";

  unpackPhase = ''
    echo -e 'q\ny' | fakeroot sh $src
  '';

  buildPhase = ''

    cd Editor

    $CC -fPIC -shared -o libunity-nosuid.so $nosuidLib -ldl
    strip libunity-nosuid.so

    cd ..
  '';

  installPhase = ''
    unitydir="$out/opt/Unity/Editor"
    mkdir -p $unitydir
    mv Editor/* $unitydir
    ln -sf /run/wrappers/bin/${chromium.sandboxExecutableName} $unitydir/chrome-sandbox

    mkdir -p $out/share/applications
    sed "/^Exec=/c\Exec=$out/bin/unity-editor" \
      < unity-editor.desktop \
      > $out/share/applications/unity-editor.desktop

    install -D unity-editor-icon.png $out/share/icons/hicolor/256x256/apps/unity-editor-icon.png

    mkdir -p $out/bin
    makeWrapper $unitydir/Unity $out/bin/unity-editor \
      --prefix LD_PRELOAD : "$unitydir/libunity-nosuid.so" \
      --prefix PATH : "${binPath}"

    developdir="$monodevelop/opt/Unity/MonoDevelop"
    mkdir -p $developdir
    mv MonoDevelop/* $developdir

    mkdir -p $monodevelop/share/applications
    sed "/^Exec=/c\Exec=$monodevelop/bin/unity-monodevelop" \
      < unity-monodevelop.desktop \
      > $monodevelop/share/applications/unity-monodevelop.desktop

    mkdir -p $monodevelop/bin
    makeWrapper $developdir/bin/monodevelop $monodevelop/bin/unity-monodevelop \
      --prefix PATH : "${developBinPath}" \
      --prefix LD_LIBRARY_PATH : "${developLibPath}" \
      --prefix MONO_GAC_PREFIX : "${developDotnetPath}"
  '';

  preFixup = ''
    patchFile() {
      ftype="$(file -b "$1")"
      if [[ "$ftype" =~ LSB\ .*dynamically\ linked ]]; then
        if [[ "$ftype" =~ 32-bit ]]; then
          rpath="${libPath32}"
          intp="$(cat $NIX_CC/nix-support/dynamic-linker-m32)"
        else
          rpath="${libPath64}"
          intp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        fi

        oldRpath="$(patchelf --print-rpath "$1")"
        # Always search at least for libraries in origin directory.
        rpath="''${oldRpath:-\$ORIGIN}:$rpath"
        if [[ "$ftype" =~ LSB\ shared ]]; then
          patchelf \
            --set-rpath "$rpath" \
            "$1"
        elif [[ "$ftype" =~ LSB\ executable ]]; then
          patchelf \
            --set-rpath "$rpath" \
            --interpreter "$intp" \
            "$1"
        fi
      fi
    }

    # Exclude PlaybackEngines to build something that can be run on FHS-compliant Linuxes
    find $unitydir -name PlaybackEngines -prune -o -type f -print | while read path; do
      patchFile "$path"
    done
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with stdenv.lib; {
    homepage = https://unity3d.com/;
    description = "Game development tool";
    longDescription = ''
      Popular development platform for creating 2D and 3D multiplatform games
      and interactive experiences.
    '';
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jb55 ];
  };
}
