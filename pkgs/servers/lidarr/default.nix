{ stdenv, fetchurl, mono, libmediainfo, sqlite, curl, chromaprint, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lidarr";
  version = "0.7.2.1878";

  src = fetchurl {
    url = "https://github.com/lidarr/Lidarr/releases/download/v${version}/Lidarr.master.${version}.linux.tar.gz";
    sha256 = "0kv0x3vvv4rp3i5k5985zp95mm8ca7gpm7kr82l11v3hm3n6yvqn";
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
