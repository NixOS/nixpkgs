{ stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "lidarr";
  version = "0.6.2.883";

  src = fetchurl {
    url = "https://github.com/lidarr/Lidarr/releases/download/v${version}/Lidarr.develop.${version}.linux.tar.gz";
    sha256 = "0096j2vph739h288vnz481nrwaq540faplir394xqfz7ik0krg4v";
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
