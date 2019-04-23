{ stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "lidarr-${version}";
  version = "0.6.0.815";

  src = fetchurl {
    url = "https://github.com/lidarr/Lidarr/releases/download/v${version}/Lidarr.develop.${version}.linux.tar.gz";
    sha256 = "08aa286y71pzn8wxjiag1bn5303i05jznqwmgrbqfb4jwz94pyjs";
  };

  buildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/

    # Mark all executable files as non-executable
    find $out/bin -type f -executable | xargs chmod -x

    makeWrapper "${mono}/bin/mono" $out/bin/Lidarr \
      --add-flags "$out/bin/Lidarr.exe" \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [
          curl sqlite libmediainfo ]}
  '';

  meta = with stdenv.lib; {
    description = "A Usenet/BitTorrent music downloader";
    homepage = https://lidarr.audio/;
    license = licenses.gpl3;
    maintainers = [ maintainers.etu ];
    platforms = platforms.all;
  };
}
