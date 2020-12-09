{ stdenv, fetchurl, boost, curl, ffmpeg, icoutils, libGLU, libmad, libogg
, libpng, libsndfile, libvorbis, lua, pkgconfig, SDL2, SDL2_image, SDL2_net
, SDL2_ttf, smpeg, speex, zziplib, zlib, makeWrapper, makeDesktopItem, unzip
, alephone }:

let
  self = stdenv.mkDerivation rec {
    outputs = [ "out" "icons" ];
    pname = "alephone";
    version = "1.3.1";

    src = fetchurl {
      url = let date = "20200904";
      in "https://github.com/Aleph-One-Marathon/alephone/releases/download/release-${date}/AlephOne-${date}.tar.bz2";
      sha256 = "13ck3mp9qd5pkiq6zwvr744bwvmnqkgj5vpf325sz1mcvnv7l8lh";
    };

    nativeBuildInputs = [ pkgconfig icoutils ];

    buildInputs = [
      boost
      curl
      ffmpeg
      libGLU
      libmad
      libsndfile
      libogg
      libpng
      libvorbis
      lua
      SDL2
      SDL2_image
      SDL2_net
      SDL2_ttf
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

      meta = alephone.meta // {
        license = stdenv.lib.licenses.free;
        hydraPlatforms = [ ];
      } // meta;
    });
}
