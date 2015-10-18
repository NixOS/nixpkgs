{ GConf
, alsaLib
, fetchurl
, stdenv
, makeWrapper
, cairo
, libcap
, cups
, dbus
, expat
, postgresql
, fontconfig
, freetype
, gdk_pixbuf
, getopt
, fakeroot
, glib
, gtk
, mesa_glu
, nspr
, nss
, pango
, xorg
, monodevelop
, xdg_utils
}:

let
  deps = [
    GConf
    alsaLib
    cairo
    cups
    libcap
    dbus
    expat
    fontconfig
    freetype
    glib
    gtk
    gdk_pixbuf
    mesa_glu
    nspr
    postgresql
    nss
    pango
    xorg.libXcomposite
    xorg.libX11
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
  ];
  libPath = stdenv.lib.makeLibraryPath deps;
  ver = "5.1.0";
  build = "f3";
  date = "2015091501";
  pkgVer = "${ver}${build}";
  fullVer = "${pkgVer}+${date}";
in stdenv.mkDerivation rec {
  name = "unity-editor-${version}";
  version = pkgVer;
  buildInputs = [ makeWrapper monodevelop xdg_utils getopt fakeroot ];

  src = fetchurl {
    url = "http://download.unity3d.com/download_unity/unity-editor-installer-${fullVer}.sh";
    sha256 = "77b351d80fc4b63284f118093df486e16c13d7b136debae6534245878029a5ca";
  };

  outputs = ["out" "sandbox"];

  unpackPhase = ''
    # 'yes | fakeroot'
    echo -e 'q\ny' | fakeroot sh $src
    sourceRoot="unity-editor-${pkgVer}"
  '';

  installPhase = ''
    unitydir=$out/opt/Unity

    mkdir -p $out/{bin,opt}
    mkdir -p $sandbox/bin
    mkdir -p $unitydir
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/{256x256,48x48}/apps

    mv Editor $unitydir
    mv MonoDevelop $unitydir

    echo "exec $unitydir/Editor/Unity \"\$@\"" > $out/bin/unity-editor
    chmod +x $out/bin/unity-editor

    sed "/^Exec=/c\Exec=$out/bin/unity-editor" < unity-editor.desktop \
                                               > $out/share/applications/unity-editor.desktop

    #sed -i "/^Exec=/c\Exec=$out/bin/monodevelop-unity" unity-monodevelop.desktop

    cp unity-editor-icon.png $out/share/icons/hicolor/256x256/apps
    # cp $unitydir/unity-monodevelop.png $out/share/icons/hicolor/48x48/apps

    rpath="$unitydir/Editor/Data/Tools:$unitydir/Editor:${stdenv.cc.cc}/lib"

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $unitydir/Editor/chrome-sandbox

    cp $unitydir/Editor/chrome-sandbox $sandbox/bin
    rm  $unitydir/Editor/chrome-sandbox

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "$rpath" \
      $unitydir/Editor/Unity

    wrapProgram $out/bin/unity-editor \
      --prefix LD_LIBRARY_PATH : "${libPath}"

  '';

  dontStrip = true;

  meta = {
    homepage = https://unity3d.com/;
    description = "Game development tool";
    longDescription = ''
      Popular development platform for creating 2D and 3D multiplatform games
      and interactive experiences.
    '';
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ jb55 ];
  };
}
