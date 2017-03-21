{ stdenv, fetchurl, mono, libmediainfo, sqlite, makeWrapper, ... }:

stdenv.mkDerivation rec {
  name = "radarr-${version}";
  version = "0.2.0.535";

  src = fetchurl {
    url = "https://github.com/Radarr/Radarr/releases/download/v${version}/Radarr.develop.${version}.linux.tar.gz";
    sha256 = "1ccvblklqn5iki7gc16bzzbwms28mv4kxzv1nwhlm9vf0cw4qxbr";
  };

  buildInputs = [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/

    makeWrapper "${mono}/bin/mono" $out/bin/radarr \
      --add-flags "$out/bin/Radarr.exe" \
      --prefix LD_LIBRARY_PATH ':' "${sqlite.out}/lib" \
      --prefix LD_LIBRARY_PATH ':' "${libmediainfo}/lib"
  '';

  meta = {
    description = "A fork of Sonarr to work with movies à la Couchpotato";
    homepage = https://radarr.video/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.fadenb ];
    platforms = stdenv.lib.platforms.all;
  };
}
