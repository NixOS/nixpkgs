{ stdenv, fetchurl, dpkg, xorg
, glib, libGLU_combined, libpulseaudio, zlib, dbus, fontconfig, freetype
, gtk3, pango
, makeWrapper , python, pythonPackages, lib
, lsof, curl, libuuid, cups, mesa
}:

let
  all_data = builtins.fromJSON (builtins.readFile ./data.json);
  system_map = {
    # i686-linux = "i386"; Uncomment if enpass 6 becomes available on i386
    x86_64-linux = "amd64";
  };

  data = all_data.${system_map.${stdenv.hostPlatform.system} or (throw "Unsupported platform")};

  baseUrl = http://repo.sinew.in;

  # used of both wrappers and libpath
  libPath = lib.makeLibraryPath (with xorg; [
    mesa.drivers
    libGLU_combined
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
    glib
    gtk3
    pango
    curl
    libuuid
    cups
  ]);
  package = stdenv.mkDerivation rec {

    inherit (data) version;
    pname = "enpass";

    src = fetchurl {
      inherit (data) sha256;
      url = "${baseUrl}/${data.path}";
    };

    meta = {
      description = "a well known password manager";
      homepage = https://www.enpass.io/;
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" "i686-linux"];
    };

    buildInputs = [makeWrapper dpkg];
    phases = [ "unpackPhase" "installPhase" ];

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
        --prefix PATH : ${lsof}/bin
    '';
  };
  updater = {
    update = stdenv.mkDerivation rec {
      name = "enpass-update-script";
      SCRIPT =./update_script.py;

      buildInputs = with pythonPackages; [python requests pathlib2 six attrs ];
      shellHook = ''
      exec python $SCRIPT --target pkgs/tools/security/enpass/data.json --repo ${baseUrl}
      '';

    };
  };
in (package // {refresh = updater;})
