{ stdenv, requireFile, makeWrapper, innoextract, openrct2-engine }:

let
  originalExecutable = "setup_rollercoaster_tycoon_2.exe";
in
  stdenv.mkDerivation rec {
    name = "openrct2-${version}";
    version = "0.0.4";

    meta = {
      description = ''An open source re-implementation of Roller Coaster Tycoon 2 (using GOG assets)'';
      longDescription = ''
        This package will attempt to install OpenRCT2 using the assets
        from the GOG installer for RollerCoaster Tycoon 2: Triple Thrill
        Pack. If you just want to install OpenRCT2 itself and specify the
        assets manually, install 'openrct2-engine' instead.

        OpenRCT2 is an open-source re-implementation of RollerCoaster
        Tycoon 2 (RCT2). The gameplay revolves around building and
        maintaining an amusement park containing attractions, shops
        and facilities. The player must try to make a profit and
        maintain a good park reputation whilst keeping the guests
        happy. OpenRCT2 allows for both scenario and sandbox play.

        Scenarios require the player to complete a certain objective
        in a set time limit whilst sandbox allows the player to build
        a more flexible park with optionally no restrictions or
        finance.
      '';
      homepage = http://www.openrct2.website/;
      license = stdenv.lib.licenses.unfree;
      platforms = stdenv.lib.platforms.linux;
      maintainers = with stdenv.lib.maintainers; [ joepie91 ];
    };

    src = requireFile {
      message = ''
        OpenRCT2 requires the assets of the original RollerCoaster Tycoon 2 game to run.
        To automatically extract these assets, you should provide the GOG installer, using
        a command that looks something like this:

          nix-prefetch-url file:///path/to/${originalExecutable}

        ... or alternatively, install 'openrct2-engine' instead. The game will then ask you
            to locate the asset directory when you start it for the first time.
      '';
      name = originalExecutable;
      sha256 = "68c2a43388967dbdf45e716263eab6bd1d9c8fb51e8d89a76a028e97754618da";
    };

    phases = "unpackPhase installPhase";

    buildInputs = [
      openrct2-engine makeWrapper
    ];

    unpackPhase = ''
      ${innoextract}/bin/innoextract -egd original_assets/ ${src}
      cd original_assets
    '';

    installPhase = ''
      echo "Moving assets..."
      mkdir -p "$out/assets"
      mv app/* "$out/assets/"

      # Temporary workaround for OpenRCT2/OpenRCT2#3981
      # WARNING: this will modify the configuration file in the user's homedir on every launch.
      echo "Patching in asset path configuration..."
      makeWrapper "${openrct2-engine}/bin/openrct2" "$out/bin/openrct2" \
        --run "${openrct2-engine}/bin/openrct2 set-rct2 $out/assets/"
    '';
  }