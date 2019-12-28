{ stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "radarr";
  version = "0.2.0.1450";

  src = fetchurl {
    url = "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.develop.${version}.linux.tar.gz";
    sha256 = "00c09e64b985c75d4cfd98b5fec52e8274c155ccb61d907dfeaf5e179dc176ea";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${mono}/bin/mono" $out/bin/Radarr \
      --add-flags "$out/share/${pname}-${version}/Radarr.exe" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
          curl sqlite libmediainfo ]}
  '';

  meta = with stdenv.lib; {
    description = "A Usenet/BitTorrent movie downloader";
    homepage = https://radarr.video/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.all;
  };
}
