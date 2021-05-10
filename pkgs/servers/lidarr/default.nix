{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, chromaprint, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lidarr";
  version = "0.8.1.2135";

  src = fetchurl {
    url = "https://github.com/lidarr/Lidarr/releases/download/v${version}/Lidarr.master.${version}.linux.tar.gz";
    sha256 = "sha256-eJX6t19D2slX68fXSMd/Vix3XSgCVylK+Wd8VH9jsuI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/

    # Mark main executable as executable
    chmod +x $out/bin/Lidarr.exe

    makeWrapper "${mono}/bin/mono" $out/bin/Lidarr \
      --add-flags "$out/bin/Lidarr.exe" \
      --prefix PATH : ${lib.makeBinPath [ chromaprint ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
          curl sqlite libmediainfo ]}
  '';

  meta = with lib; {
    description = "A Usenet/BitTorrent music downloader";
    homepage = "https://lidarr.audio/";
    license = licenses.gpl3;
    maintainers = [ maintainers.etu ];
    platforms = platforms.all;
  };
}
