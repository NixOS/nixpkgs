{ stdenv, fetchurl, boost, curl, ffmpeg, icoutils, libmad, libogg, libpng
, libsndfile, libvorbis, lua, pkgconfig, SDL, SDL_image, SDL_net, SDL_ttf, smpeg
, speex, zziplib, zlib, makeWrapper, makeDesktopItem, unzip, alephone }:

let
  self = stdenv.mkDerivation rec {
    outputs = [ "out" "icons" ];
    pname = "alephone";
    version = "20150620";

    src = fetchurl {
      url =
        "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${version}/AlephOne-${version}.tar.bz2";
      sha256 = "0cz18fa3gx8mz5j09ywz8gq0r4q082kh6l9pbpwn8qjanzgn1wy0";
    };

    nativeBuildInputs = [ pkgconfig icoutils ];

    buildInputs = [
      boost
      curl
      ffmpeg
      libmad
      libsndfile
      libogg
      libpng
      libvorbis
      lua
      SDL
      SDL_image
      SDL_net
      SDL_ttf
      smpeg
      speex
      zziplib
      zlib
    ];

    configureFlags = [ "--with-boost=${boost}" ];

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

    meta = with stdenv.lib; {
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
        categories = "Game;";
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

      meta = with stdenv.lib;
        {
          maintainers = with maintainers; [ ehmry ];
          inherit (alephone.meta) platforms;
        } // meta;
    } // extraArgs);
}
