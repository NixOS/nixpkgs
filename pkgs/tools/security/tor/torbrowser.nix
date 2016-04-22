{ stdenv, fetchurl, buildEnv, makeDesktopItem
, xorg, alsaLib, dbus, dbus_glib, glib, gtk, atk, pango, freetype, fontconfig
, gdk_pixbuf, cairo, zlib}:
let
  # isolated tor environment
  torEnv = buildEnv {
    name = "tor-env";
    paths = [
      stdenv.cc.cc zlib glib alsaLib dbus dbus_glib gtk atk pango freetype
      fontconfig gdk_pixbuf cairo xorg.libXrender xorg.libX11 xorg.libXext
      xorg.libXt
    ];
    extraOutputsToInstall = [ "lib" "out" ];
  };

  ldLibraryPath = ''${torEnv}/lib${stdenv.lib.optionalString stdenv.is64bit ":${torEnv}/lib64"}'';

in stdenv.mkDerivation rec {
  name = "tor-browser-${version}";
  version = "5.5.4";

  src = fetchurl {
    url = "https://archive.torproject.org/tor-package-archive/torbrowser/${version}/tor-browser-linux${if stdenv.is64bit then "64" else "32"}-${version}_en-US.tar.xz";
    sha256 = if stdenv.is64bit then
      "0sjx2r7z7s3x1ygs9xak1phng13jcf4d5pcfyfrfsrd8kb1yn8xa" else
      "0w9wk9hk57hyhhx7l4sr2x64ki9882fr6py2can1slr7kbb4mhpb";
  };

  desktopItem = makeDesktopItem {
    name = "torbrowser";
    exec = "tor-browser";
    icon = "torbrowser";
    desktopName = "Tor Browser";
    genericName = "Tor Browser";
    comment = meta.description;
    categories = "Network;WebBrowser;Security;";
  };

  patchPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" Browser/firefox
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" Browser/TorBrowser/Tor/tor
  '';

  doCheck = true;
  checkPhase = ''
    # Just do a simple test if all libraries get loaded by running help on
    # firefox and tor
    echo "Checking firefox..."
    LD_LIBRARY_PATH=${ldLibraryPath} Browser/firefox --help 1> /dev/null
    echo "Checking tor..."
    LD_LIBRARY_PATH=${torEnv}/lib:Browser/TorBrowser/Tor Browser/TorBrowser/Tor/tor --help 1> /dev/null
  '';

  installPhase = ''
    mkdir -p $out/share/tor-browser
    mkdir -p $out/bin
    cp -R * $out/share/tor-browser

    cat > "$out/bin/tor-browser" << EOF
    #!${stdenv.shell}
    export HOME="\$HOME/.torbrowser4"
    if [ ! -d \$HOME ]; then
      mkdir -p \$HOME && cp -R $out/share/tor-browser/Browser/TorBrowser/Data \$HOME/ && chmod -R +w \$HOME
      echo "pref(\"extensions.torlauncher.tordatadir_path\", \"\$HOME/Data/Tor/\");" >> \
        ~/Data/Browser/profile.default/preferences/extension-overrides.js
    fi
    export LD_LIBRARY_PATH=${ldLibraryPath}:$out/share/tor-browser/Browser/TorBrowser/Tor
    $out/share/tor-browser/Browser/firefox -no-remote -profile ~/Data/Browser/profile.default "$@"
    EOF
    chmod +x $out/bin/tor-browser

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications

    mkdir -p $out/share/pixmaps
    cp Browser/browser/icons/mozicon128.png $out/share/pixmaps/torbrowser.png
  '';

  buildInputs = [ stdenv ];

  meta = with stdenv.lib; {
    description = "Tor Browser Bundle";
    homepage    = https://www.torproject.org/;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ offline matejc doublec thoughtpolice ];
  };
}
