{ stdenv, fetchurl, pkgs, makeWrapper, mono, ffmpeg, ... }:

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "3.0.8500";

  src = fetchurl {
    url = "https://github.com/MediaBrowser/Emby/archive/${version}.tar.gz";
    sha256 = "0vm2yvwyhswsp31g48qdzm17c4p7c25vyiy1029hgy8nd5qy4shc";
  };

  buildInputs = with pkgs; [
    makeWrapper
  ];
  propagatedBuildInputs = with pkgs; [
    mono
    sqlite
  ];

  buildPhase = ''
    xbuild /p:Configuration="Release Mono" /p:Platform="Any CPU" /t:build MediaBrowser.Mono.sln
    substituteInPlace MediaBrowser.Server.Mono/bin/Release\ Mono/System.Data.SQLite.dll.config --replace libsqlite3.so ${pkgs.sqlite.out}/lib/libsqlite3.so
    substituteInPlace MediaBrowser.Server.Mono/bin/Release\ Mono/MediaBrowser.Server.Mono.exe.config --replace ProgramData-Server "/var/lib/emby/ProgramData-Server"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r MediaBrowser.Server.Mono/bin/Release\ Mono/* $out/bin/

    makeWrapper "${mono}/bin/mono" $out/bin/MediaBrowser.Server.Mono \
      --add-flags "$out/bin/MediaBrowser.Server.Mono.exe -ffmpeg ${ffmpeg}/bin/ffmpeg -ffprobe ${ffmpeg}/bin/ffprobe"
  '';

  meta = {
    description = "MediaBrowser - Bring together your videos, music, photos, and live television";
    homepage = http://emby.media/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
