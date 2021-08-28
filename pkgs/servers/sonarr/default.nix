{ lib, stdenv, fetchurl, mono, libmediainfo, sqlite, curl, makeWrapper, nixosTests }:

stdenv.mkDerivation rec {
  pname = "sonarr";
  version = "3.0.6.1196";

  src = fetchurl {
    url = "https://download.sonarr.tv/v3/main/${version}/Sonarr.main.${version}.linux.tar.gz";
    sha256 = "10fm5s1ayjmj0ip5510rb0nfh08gdaxin0xf2f3qw1z5kxys88fm";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/
    makeWrapper "${mono}/bin/mono" $out/bin/NzbDrone \
      --add-flags "$out/bin/Sonarr.exe" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
          curl sqlite libmediainfo ]}
  '';

  passthru = {
    updateScript = "./update.sh";
    tests.smoke-test = nixosTests.sonarr;
  };

  meta = {
    description = "Smart PVR for newsgroup and bittorrent users";
    homepage = "https://sonarr.tv/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fadenb purcell ];
    platforms = lib.platforms.all;
  };
}
