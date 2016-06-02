{ stdenv, fetchurl, mono, libmediainfo, sqlite, ... }:

stdenv.mkDerivation rec {
  name = "sonarr-${version}";
  version = "2.0.0.4146";

  src = fetchurl {
    url = "http://download.sonarr.tv/v2/master/mono/NzbDrone.master.${version}.mono.tar.gz";
    sha256 = "0hw6yzb8l549mzjq7hnnv12rl13hslaxhqy6hny6ky55rh3fj27y";
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
