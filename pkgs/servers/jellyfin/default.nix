{ stdenv, fetchurl, unzip, sqlite, makeWrapper, dotnet-sdk, ffmpeg }:

stdenv.mkDerivation rec {
  pname = "jellyfin";
  version = "10.2.2";

  # Impossible to build anything offline with dotnet
  src = fetchurl {
    url = "https://github.com/jellyfin/jellyfin/releases/download/v${version}/jellyfin_${version}_portable.tar.gz";
    sha256 = "1q5wwjhlvykcad6jcizbr4yx5fiyzs97zl4qnkf79236xgvdyx53";
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

  installPhase = ''
    install -dm 755 "$out/opt/jellyfin"
    cp -r * "$out/opt/jellyfin"

    makeWrapper "${dotnet-sdk}/bin/dotnet" $out/bin/jellyfin \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [
        sqlite
      ]}" \
      --add-flags "$out/opt/jellyfin/jellyfin.dll -ffmpeg ${ffmpeg}/bin/ffmpeg -ffprobe ${ffmpeg}/bin/ffprobe"
  '';

  meta =  with stdenv.lib; {
    description = "The Free Software Media System";
    homepage = https://jellyfin.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
