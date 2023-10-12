{ lib, stdenv, fetchurl, alsa-lib, boost, curl, ffmpeg_4, icoutils, libGLU
, libmad, libogg, libpng, libsndfile, libvorbis, lua, miniupnpc, pkg-config
, SDL2, SDL2_image, SDL2_net, SDL2_ttf, speex, zziplib, zlib, makeWrapper
, makeDesktopItem, unzip, alephone }:

let
  self = stdenv.mkDerivation rec {
    outputs = [ "out" "icons" ];
    pname = "alephone";
    version = "1.6.2";

    src = fetchurl {
      url = let date = "20230529";
      in "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${date}/AlephOne-${date}.tar.bz2";
      sha256 = "sha256-UqhZvOMOxU4W0eLRRTQvGXaqTpWD5KIdXULClHW7Iyc=";
    };

    nativeBuildInputs = [ pkg-config icoutils ];

    buildInputs = [
      alsa-lib
      boost
      curl
      ffmpeg_4
      libGLU
      libmad
      libsndfile
      libogg
      libpng
      libvorbis
      lua
      miniupnpc
      SDL2
      SDL2_image
      SDL2_net
      SDL2_ttf
      speex
      zziplib
      zlib
    ];

    configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];
    makeFlags = [ "AR:=$(AR)" ];

    enableParallelBuilding = true;

    postInstall = ''
      mkdir $icons
      icotool -x -i 5 -o $icons Resources/Windows/*.ico
      pushd $icons
      for x in *_5_48x48x32.png; do
        mv $x ''${x%_5_48x48x32.png}.png
      done
      popd
    '';

    meta = with lib; {
      description =
        "Aleph One is the open source continuation of Bungie’s Marathon 2 game engine";
      homepage = "https://alephone.lhowon.org/";
      license = with licenses; [ gpl3 ];
      maintainers = with maintainers; [ ehmry ];
      platforms = platforms.linux;
    };
  };

in self // {
  makeWrapper = { pname, desktopName, version, zip, meta
    , icon ? alephone.icons + "/alephone.png", ... }@extraArgs:
    stdenv.mkDerivation ({
      inherit pname version;

      desktopItem = makeDesktopItem {
        name = desktopName;
        exec = pname;
        genericName = pname;
        categories = [ "Game" ];
        comment = meta.description;
        inherit desktopName icon;
      };

      src = zip;

      nativeBuildInputs = [ makeWrapper unzip ];

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        mkdir -p $out/bin $out/data/$pname $out/share/applications
        cp -a * $out/data/$pname
        cp $desktopItem/share/applications/* $out/share/applications
        makeWrapper ${alephone}/bin/alephone $out/bin/$pname \
          --add-flags $out/data/$pname
      '';
    } // extraArgs // {
      meta = alephone.meta // {
        license = lib.licenses.free;
        hydraPlatforms = [ ];
      } // meta;
    });
}
