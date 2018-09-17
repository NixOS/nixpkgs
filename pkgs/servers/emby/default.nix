{ stdenv, fetchurl, unzip, sqlite, makeWrapper, mono54, ffmpeg }:

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "3.5.2.0";

  # We are fetching a binary here, however, a source build is possible.
  # See -> https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=emby-server-git#n43
  # Though in my attempt it failed with this error repeatedly
  # The type 'Attribute' is defined in an assembly that is not referenced. You must add a reference to assembly 'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'.
  # This may also need msbuild (instead of xbuild) which isn't in nixpkgs
  # See -> https://github.com/NixOS/nixpkgs/issues/29817
  src = fetchurl {
    url = "https://github.com/MediaBrowser/Emby.Releases/releases/download/${version}/embyserver-mono_${version}.zip";
    sha256 = "12f9skvnr9qxnrvr3q014yggfwvkpjk0ynbgf0fwk56h4kal7fx8";
  };

  buildInputs = [
    unzip
    makeWrapper
  ];

  propagatedBuildInputs = [
    mono54
    sqlite
  ];

  preferLocalBuild = true;

  # Need to set sourceRoot as unpacker will complain about multiple directory output
  sourceRoot = ".";

  buildPhase = ''
    substituteInPlace SQLitePCLRaw.provider.sqlite3.dll.config --replace libsqlite3.so ${sqlite.out}/lib/libsqlite3.so
    substituteInPlace MediaBrowser.Server.Mono.exe.config --replace ProgramData-Server "/var/lib/emby/ProgramData-Server"
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp -r * "$out/bin"

    makeWrapper "${mono54}/bin/mono" $out/bin/MediaBrowser.Server.Mono \
      --add-flags "$out/bin/MediaBrowser.Server.Mono.exe -ffmpeg ${ffmpeg}/bin/ffmpeg -ffprobe ${ffmpeg}/bin/ffprobe"
  '';

  meta =  with stdenv.lib; {
    description = "MediaBrowser - Bring together your videos, music, photos, and live television";
    homepage = https://emby.media/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ fadenb ];
    platforms = platforms.all;
  };
}
