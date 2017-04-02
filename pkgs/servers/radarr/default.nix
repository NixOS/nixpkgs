{ stdenv, fetchurl, mono, libmediainfo, sqlite, makeWrapper }:

stdenv.mkDerivation rec {
  name = "radarr-${version}";
  version = "0.2.0.535";

  src = fetchurl {
    url = "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.develop.${version}.linux.tar.gz";
    sha256 = "1ccvblklqn5iki7gc16bzzbwms28mv4kxzv1nwhlm9vf0cw4qxbr";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/${name}}
    cp -r * $out/share/${name}/.

    makeWrapper "${mono}/bin/mono" $out/bin/Radarr \
      --add-flags "$out/share/${name}/Radarr.exe" \
      --prefix LD_LIBRARY_PATH ':' "${sqlite.out}/lib" \
      --prefix LD_LIBRARY_PATH ':' "${libmediainfo}/lib"
  '';

  meta = with stdenv.lib; {
    description = "A Usenet/BitTorrent movie downloader.";
    homepage = https://radarr.video/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.all;
  };
}
