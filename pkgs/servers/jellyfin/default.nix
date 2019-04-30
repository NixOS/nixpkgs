{ stdenv, fetchurl, unzip, sqlite, makeWrapper, dotnet-sdk, ffmpeg }:

stdenv.mkDerivation rec {
  pname = "jellyfin";
  version = "10.3.1";

  # Impossible to build anything offline with dotnet
  src = fetchurl {
    url = "https://github.com/jellyfin/jellyfin/releases/download/v${version}/jellyfin_${version}_portable.tar.gz";
    sha256 = "1j6jyrbc0ha348y63wk5jv9wjcjydma9cr3jxva1y85pjrmm7z90";
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
      --add-flags "$out/opt/jellyfin/jellyfin.dll --ffmpeg ${ffmpeg}/bin/ffmpeg"
  '';

  meta =  with stdenv.lib; {
    description = "The Free Software Media System";
    homepage = https://jellyfin.github.io/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ nyanloutre minijackson ];
  };
}
