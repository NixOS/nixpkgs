{ stdenv, fetchurl, buildEnv
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
  };

  ldLibraryPath = ''${torEnv}/lib${stdenv.lib.optionalString stdenv.is64bit ":${torEnv}/lib64"}'';

in stdenv.mkDerivation rec {
  name = "tor-browser-${version}";
  version = "5.0.6";

  src = fetchurl {
    url = "https://archive.torproject.org/tor-package-archive/torbrowser/${version}/tor-browser-linux${if stdenv.is64bit then "64" else "32"}-${version}_en-US.tar.xz";
    sha256 = if stdenv.is64bit then
      "1ix05760l9j6bwbswd2fnk4b6nrrzxp3b8abvm4y4979pkkmasfw" else
      "1q5mf91xxj1xs4ajj9i6mdhnzqycbdvprkzskx8pl6j9ll2hlsyh";
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
  '';

  buildInputs = [ stdenv ];

  meta = {
    description = "Tor Browser Bundle";
    homepage    = https://www.torproject.org/;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers;
      [ offline matejc doublec thoughtpolice ];
  };
}
