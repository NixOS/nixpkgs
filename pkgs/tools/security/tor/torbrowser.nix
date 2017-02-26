{ stdenv, fetchurl, makeDesktopItem
, libXrender, libX11, libXext, libXt, alsaLib, dbus, dbus_glib, glib, gtk2
, atk, pango, freetype, fontconfig, gdk_pixbuf, cairo, zlib
, gstreamer, gst_plugins_base, gst_plugins_good, gst-ffmpeg, gmp, ffmpeg
, libpulseaudio
, mediaSupport ? false
}:

let
  libPath = stdenv.lib.makeLibraryPath ([
    stdenv.cc.cc zlib glib alsaLib dbus dbus_glib gtk2 atk pango freetype
    fontconfig gdk_pixbuf cairo libXrender libX11 libXext libXt
  ] ++ stdenv.lib.optionals mediaSupport [
    gstreamer gst_plugins_base gmp ffmpeg
    libpulseaudio
  ]);

  # Ignored if !mediaSupport
  gstPlugins = [ gstreamer gst_plugins_base gst_plugins_good gst-ffmpeg ];

  gstPluginsPath = stdenv.lib.concatMapStringsSep ":" (x:
    "${x}/lib/gstreamer-0.10") gstPlugins;
in

stdenv.mkDerivation rec {
  name = "tor-browser-${version}";
  version = "6.5";

  src = fetchurl {
    url = "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux${if stdenv.is64bit then "64" else "32"}-${version}_en-US.tar.xz";
    sha256 = if stdenv.is64bit then
      "0q0rdwjiqjjh9awiyp0a55nkhyri5y6zhkyq3n3x6w4afihl0wf4" else
      "1y1sx2gp7c66l7a4smfibl8mv54byvawhhkikpa5l2vic75vyhk9";
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
    ${stdenv.lib.optionalString mediaSupport ''
      export GST_PLUGIN_SYSTEM_PATH=${gstPluginsPath}
    ''}
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
