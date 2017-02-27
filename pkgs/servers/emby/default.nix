{ stdenv, fetchurl, pkgs, unzip, sqlite, makeWrapper, mono46, ffmpeg, ... }:

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "3.2.4";

  src = fetchurl {
    url = "https://github.com/MediaBrowser/Emby/releases/download/${version}/Emby.Mono.zip";
    sha256 = "0a14wr2yal9q5vlwadyki9w35bn4f3r7r5w3zynp4f7460lfapmf";
  };

  buildInputs = with pkgs; [
    unzip
    makeWrapper
  ];
  propagatedBuildInputs = with pkgs; [
    mono46
    sqlite
  ];

  # Need to set sourceRoot as unpacker will complain about multiple directory output
  sourceRoot = ".";

  buildPhase = ''
    substituteInPlace SQLitePCLRaw.provider.sqlite3.dll.config --replace libsqlite3.so ${sqlite.out}/lib/libsqlite3.so
    substituteInPlace MediaBrowser.Server.Mono.exe.config --replace ProgramData-Server "/var/lib/emby/ProgramData-Server"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin

    makeWrapper "${mono46}/bin/mono" $out/bin/MediaBrowser.Server.Mono \
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
