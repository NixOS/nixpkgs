{ stdenv, fetchurl, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "3.0.6000";

  src = fetchurl {
    url = "https://github.com/MediaBrowser/Emby/archive/${version}.tar.gz";
    sha256 = "1q1l6gl8k3rxklmw52vcpp4r6iwyhydv61zjbz5v66zpvi64w8is";
  };

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
  '';

  meta = {
    description = "MediaBrowser - Bring together your videos, music, photos, and live television";
    homepage = http://emby.media/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
