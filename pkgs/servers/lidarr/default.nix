{ stdenv, fetchurl, mono, libmediainfo, sqlite, curl, chromaprint, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lidarr";
  version = "0.7.1.1381";

  src = fetchurl {
    url = "https://github.com/lidarr/Lidarr/releases/download/v${version}/Lidarr.master.${version}.linux.tar.gz";
    sha256 = "1vk1rlsb48ckdc4421a2qs0v5gy7kc4fad24dm3k14znh7llwypr";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/

    # Mark main executable as executable
    chmod +x $out/bin/Lidarr.exe

    makeWrapper "${mono}/bin/mono" $out/bin/Lidarr \
      --add-flags "$out/bin/Lidarr.exe" \
      --prefix PATH : ${stdenv.lib.makeBinPath [ chromaprint ]} \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
          curl sqlite libmediainfo ]}
  '';

  meta = with stdenv.lib; {
    description = "A Usenet/BitTorrent music downloader";
    homepage = "https://lidarr.audio/";
    license = licenses.gpl3;
    maintainers = [ maintainers.etu ];
    platforms = platforms.all;
  };
}
