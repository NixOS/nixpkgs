{ stdenv, fetchurl, pkgs, unzip, sqlite, makeWrapper, mono, ffmpeg, ... }:

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "3.5.2.0";

  src = fetchurl {
    url = "https://github.com/MediaBrowser/Emby.Releases/releases/download/${version}/embyserver-mono_${version}.zip";
    sha256 = "12f9skvnr9qxnrvr3q014yggfwvkpjk0ynbgf0fwk56h4kal7fx8";
  };

  buildInputs = with pkgs; [
    unzip
    makeWrapper
  ];
  propagatedBuildInputs = with pkgs; [
    mono
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

    makeWrapper "${mono}/bin/mono" $out/bin/MediaBrowser.Server.Mono \
      --add-flags "$out/bin/MediaBrowser.Server.Mono.exe -ffmpeg ${ffmpeg}/bin/ffmpeg -ffprobe ${ffmpeg}/bin/ffprobe"
  '';

  meta = {
    description = "MediaBrowser - Bring together your videos, music, photos, and live television";
    homepage = https://emby.media/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
