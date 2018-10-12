{ stdenv, fetchurl, unzip, sqlite, makeWrapper, dotnet-sdk, ffmpeg }:

stdenv.mkDerivation rec {
  name = "emby-${version}";
  version = "3.5.3.0";

  # We are fetching a binary here, however, a source build is possible.
  # See -> https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=emby-server-git#n43
  # Though in my attempt it failed with this error repeatedly
  # The type 'Attribute' is defined in an assembly that is not referenced. You must add a reference to assembly 'netstandard, Version=2.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51'.
  # This may also need msbuild (instead of xbuild) which isn't in nixpkgs
  # See -> https://github.com/NixOS/nixpkgs/issues/29817
  src = fetchurl {
    url = "https://github.com/MediaBrowser/Emby.Releases/releases/download/${version}/embyserver-netcore_${version}.zip";
    sha256 = "0311af3q813cx0ykbdk9vkmnyqi2l8rx66jnvdkw927q6invnnpj";
  };

  buildInputs = [
    unzip
    makeWrapper
  ];

  propagatedBuildInputs = [
    dotnet-sdk
    sqlite
  ];

  preferLocalBuild = true;

  buildPhase = ''
    rm -rf {electron,runtimes}
  '';

  installPhase = ''
    install -dm 755 "$out/opt/emby-server"
    cp -r * "$out/opt/emby-server"

    makeWrapper "${dotnet-sdk}/bin/dotnet" $out/bin/emby \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [
        sqlite
      ]}" \
      --add-flags "$out/opt/emby-server/EmbyServer.dll -ffmpeg ${ffmpeg}/bin/ffmpeg -ffprobe ${ffmpeg}/bin/ffprobe"
  '';

  meta =  with stdenv.lib; {
    description = "MediaBrowser - Bring together your videos, music, photos, and live television";
    homepage = https://emby.media/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ fadenb ];
    platforms = platforms.all;
  };
}
