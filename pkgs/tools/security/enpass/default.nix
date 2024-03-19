{ stdenv, fetchurl, dpkg, xorg
, glib, libGLU, libGL, libpulseaudio, zlib, dbus, fontconfig, freetype
, gtk3, pango
, makeWrapper , python3Packages, lib, libcap
, lsof, curl, libuuid, cups, mesa, xz, libxkbcommon
}:

let
  all_data = lib.importJSON ./data.json;
  system_map = {
    # i686-linux = "i386"; Uncomment if enpass 6 becomes available on i386
    x86_64-linux = "amd64";
  };

  data = all_data.${system_map.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")};

  baseUrl = "https://apt.enpass.io";

  # used of both wrappers and libpath
  libPath = lib.makeLibraryPath (with xorg; [
    mesa.drivers
    libGLU libGL
    fontconfig
    freetype
    libpulseaudio
    zlib
    dbus
    libX11
    libXi
    libSM
    libICE
    libXrender
    libXScrnSaver
    libxcb
    libcap
    glib
    gtk3
    pango
    curl
    libuuid
    cups
    xcbutilwm         # libxcb-icccm.so.4
    xcbutilimage      # libxcb-image.so.0
    xcbutilkeysyms    # libxcb-keysyms.so.1
    xcbutilrenderutil # libxcb-render-util.so.0
    xz
    libxkbcommon
  ]);
  package = stdenv.mkDerivation {

    inherit (data) version;
    pname = "enpass";

    src = fetchurl {
      inherit (data) sha256;
      url = "${baseUrl}/${data.path}";
    };

    meta = with lib; {
      description = "A well known password manager";
      homepage = "https://www.enpass.io/";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      platforms = [ "x86_64-linux" "i686-linux"];
      maintainers = with maintainers; [ ewok dritter ];
    };

    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [dpkg];

    unpackPhase = "dpkg -X $src .";
    installPhase=''
      mkdir -p $out/bin
      cp -r opt/enpass/*  $out/bin
      cp -r usr/* $out

      sed \
        -i s@/opt/enpass/Enpass@$out/bin/Enpass@ \
        $out/share/applications/enpass.desktop

      for i in $out/bin/{Enpass,importer_enpass}; do
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $i
      done

      # lsof must be in PATH for proper operation
      wrapProgram $out/bin/Enpass \
        --set LD_LIBRARY_PATH "${libPath}" \
        --prefix PATH : ${lsof}/bin \
        --unset QML2_IMPORT_PATH \
        --unset QT_PLUGIN_PATH
    '';
  };
  updater = {
    update = stdenv.mkDerivation {
      name = "enpass-update-script";
      SCRIPT =./update_script.py;

      buildInputs = with python3Packages; [python requests pathlib2 six attrs ];
      shellHook = ''
        exec python $SCRIPT --target pkgs/tools/security/enpass/data.json --repo ${baseUrl}
      '';

    };
  };
in (package // {refresh = updater;})
