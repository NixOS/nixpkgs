{ stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "radarr-${version}";
  version = "0.2.0.1344";

  src = fetchurl {
    url = "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.develop.${version}.linux.tar.gz";
    sha256 = "0zh1p92i61s6mx26s3fvzg1ihsx433b398wsl5p8zafwqq3zfrla";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${name}}
    cp -r * $out/share/${name}/.

    makeWrapper "${mono}/bin/mono" $out/bin/Radarr \
      --add-flags "$out/share/${name}/Radarr.exe" \
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
