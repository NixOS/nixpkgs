{ stdenv, fetchurl, mono, libmediainfo, sqlite, ... }:

stdenv.mkDerivation rec {
  name = "sonarr-${version}";
  version = "2.0.0.4230";

  src = fetchurl {
    url = "http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${version}.mono.tar.gz";
    sha256 = "16nx0v5hpqlwna2hzpcpzvm7qc361yjxbqnwz5bfnnkb0h7ik5m6";
  };

  propagatedBuildInputs = [
    mono
    libmediainfo
    sqlite
  ];

  patches = [
    ./SQLite.dll.config.patch
  ];

  postPatch = ''
    substituteInPlace System.Data.SQLite.dll.config --replace libsqlite3.so ${sqlite.out}/lib/libsqlite3.so
    substituteInPlace NzbDrone.Core.dll.config --replace libmediainfo.so ${libmediainfo}/lib/libmediainfo.so
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin
  '';

  meta = {
    description = "Sonarr - Smart PVR for newsgroup and bittorrent users";
    homepage = https://sonarr.tv/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
