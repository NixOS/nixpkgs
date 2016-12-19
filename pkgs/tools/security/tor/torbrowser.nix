{ stdenv, fetchurl, makeDesktopItem
, libXrender, libX11, libXext, libXt, alsaLib, dbus, dbus_glib, glib, gtk2
, atk, pango, freetype, fontconfig, gdk_pixbuf, cairo, zlib
, gstreamer, gst_plugins_base, gst_plugins_good, gst_ffmpeg, gmp, ffmpeg
, libpulseaudio
}:

let
  libPath = stdenv.lib.makeLibraryPath [
    stdenv.cc.cc zlib glib alsaLib dbus dbus_glib gtk2 atk pango freetype
    fontconfig gdk_pixbuf cairo libXrender libX11 libXext libXt
    gstreamer gst_plugins_base gmp ffmpeg
    libpulseaudio
  ] ;

  gstPlugins = [ gstreamer gst_plugins_base gst_plugins_good gst_ffmpeg ];

  gstPluginsPath = stdenv.lib.concatMapStringsSep ":" (x:
    "${x}/lib/gstreamer-0.10") gstPlugins;
in

stdenv.mkDerivation rec {
  name = "tor-browser-${version}";
  version = "6.0.8";

  src = fetchurl {
    url = "https://archive.torproject.org/tor-package-archive/torbrowser/${version}/tor-browser-linux${if stdenv.is64bit then "64" else "32"}-${version}_en-US.tar.xz";
    sha256 = if stdenv.is64bit then
      "1s2yv72kj4zxba0850fi1jv41c69vcw3inhj9kqhy1d45ql7iw0w" else
      "0zvqf444h35ikv1f3nwkh2jx51zj5k9w4zdxx32zcrnxpk5nhn97";
  };

  preferLocalBuild = true;

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

    sed -e "s,./TorBrowser,$out/share/tor-browser/Browser/TorBrowser,g" -i Browser/TorBrowser/Data/Tor/torrc-defaults
  '';

  doCheck = true;
  checkPhase = ''
    echo "Checking firefox..."
    LD_LIBRARY_PATH=${libPath} Browser/firefox --help 1> /dev/null
    echo "Checking tor..."
    LD_LIBRARY_PATH=${libPath}:Browser/TorBrowser/Tor Browser/TorBrowser/Tor/tor --help 1> /dev/null
  '';

  installPhase = ''
    mkdir -p $out/share/tor-browser
    mkdir -p $out/bin
    cp -R * $out/share/tor-browser

    cat > "$out/bin/tor-browser" << EOF
    #! ${stdenv.shell}
    unset SESSION_MANAGER
    export HOME="\$HOME/.torbrowser4"
    if [ ! -d \$HOME ]; then
      mkdir -p \$HOME && cp -R $out/share/tor-browser/Browser/TorBrowser/Data \$HOME/ && chmod -R +w \$HOME
      echo "pref(\"extensions.torlauncher.tordatadir_path\", \"\$HOME/Data/Tor/\");" >> \
        ~/Data/Browser/profile.default/preferences/extension-overrides.js
      echo "pref(\"extensions.torlauncher.torrc-defaults_path\", \"\$HOME/Data/Tor/torrc-defaults\");" >> \
        ~/Data/Browser/profile.default/preferences/extension-overrides.js
      echo "pref(\"extensions.torlauncher.tor_path\", \"$out/share/tor-browser/Browser/TorBrowser/Tor/tor\");" >> \
        ~/Data/Browser/profile.default/preferences/extension-overrides.js
    fi
    export FONTCONFIG_PATH=\$HOME/Data/fontconfig
    export LD_LIBRARY_PATH=${libPath}:$out/share/tor-browser/Browser/TorBrowser/Tor
    export GST_PLUGIN_SYSTEM_PATH=${gstPluginsPath}
    exec $out/share/tor-browser/Browser/firefox --class "Tor Browser" -no-remote -profile ~/Data/Browser/profile.default "\$@"
    EOF
    chmod +x $out/bin/tor-browser

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications

    mkdir -p $out/share/pixmaps
    cp Browser/browser/icons/mozicon128.png $out/share/pixmaps/torbrowser.png
  '';

  meta = with stdenv.lib; {
    description = "Tor Browser Bundle";
    homepage    = https://www.torproject.org/;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ offline matejc doublec thoughtpolice joachifm ];
  };
}
