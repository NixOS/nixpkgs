{ stdenv, fetchurl, buildEnv
, xlibs, alsaLib, dbus, dbus_glib, glib, gtk, atk, pango, freetype, fontconfig
, gdk_pixbuf, cairo, zlib}:
let
  bits = if stdenv.system == "x86_64-linux" then "64"
         else "32";

  # isolated tor environment
  torEnv = buildEnv {
    name = "tor-env";
    paths = [
      stdenv.gcc.gcc zlib glib alsaLib dbus dbus_glib gtk atk pango freetype
      fontconfig gdk_pixbuf cairo xlibs.libXrender xlibs.libX11 xlibs.libXext
      xlibs.libXt
    ];
  };

  ldLibraryPath = if bits == "64" then torEnv+"/lib:"+torEnv+"/lib64"
        else torEnv+"/lib";

in stdenv.mkDerivation rec {
  name = "tor-browser-${version}";
  version = "3.6.2";

  src = fetchurl {
    url = "https://archive.torproject.org/tor-package-archive/torbrowser/${version}/tor-browser-linux${bits}-${version}_en-US.tar.xz";
    sha256 = if bits == "64" then
      "1rfv59k9mia6hr1z1k4im20dy59ir7i054cgf78sfj1zsh08q7hf" else
      "1klkk1k5r51pcx44r1z3sw08fqcl2f2v5iblf4yh83js482c37r8";
  };

  patchPhase = ''
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" Browser/firefox
    patchelf --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" Tor/tor
  '';

  doCheck = true;
  checkPhase = ''
    # Just do a simple test if all libraries get loaded by running help on
    # firefox and tor
    echo "Checking firefox..."
    LD_LIBRARY_PATH=${ldLibraryPath} Browser/firefox --help 1> /dev/null
    echo "Checking tor..."
    LD_LIBRARY_PATH=${torEnv}/lib:Tor Tor/tor --help 1> /dev/null
  '';

  installPhase = ''
    ensureDir $out/share/tor-browser
    ensureDir $out/bin
    cp -R * $out/share/tor-browser

    cat > "$out/bin/tor-browser" << EOF
      export HOME="\$HOME/.torbrowser"
      if [ ! -d \$HOME ]; then
        mkdir -p \$HOME && cp -R $out/share/tor-browser/Data \$HOME/ && chmod -R +w \$HOME
        echo "pref(\"extensions.torlauncher.tordatadir_path\", \"\$HOME/Data/Tor/\");" >> \
          ~/Data/Browser/profile.default/preferences/extension-overrides.js
      fi
      export LD_LIBRARY_PATH=${ldLibraryPath}:$out/share/tor-browser/Tor
      $out/share/tor-browser/Browser/firefox -no-remote -profile ~/Data/Browser/profile.default "$@"
    EOF
    chmod +x $out/bin/tor-browser
  '';

  buildInputs = [ stdenv ];

  meta = with stdenv.lib; {
    description = "Tor Browser Bundle for GNU/Linux, everything you need to safely browse the Internet";
    homepage = https://www.torproject.org/;
    platforms = ["i686-linux" "x86_64-linux"];
    maintainers = [ maintainers.offline maintainers.matejc ];
  };
}
