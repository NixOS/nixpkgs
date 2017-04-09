{ stdenv, fetchurl, mono, libmediainfo, sqlite, makeWrapper, ... }:

stdenv.mkDerivation rec {
  name = "sonarr-${version}";
  version = "2.0.0.4689";

  src = fetchurl {
    url = "http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${version}.mono.tar.gz";
    sha256 = "056ndn98byn6gkiq46vn8pl0s715ni7wklxnmid2hk5xwyjy7bwk";
  };

  buildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/

    makeWrapper "${mono}/bin/mono" $out/bin/NzbDrone \
      --add-flags "$out/bin/NzbDrone.exe" \
      --prefix LD_LIBRARY_PATH ':' "${sqlite.out}/lib" \
      --prefix LD_LIBRARY_PATH ':' "${libmediainfo}/lib"
  '';

  meta = {
    description = "Smart PVR for newsgroup and bittorrent users";
    homepage = https://sonarr.tv/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
