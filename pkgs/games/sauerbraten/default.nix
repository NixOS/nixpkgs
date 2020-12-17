{ stdenv, fetchzip, SDL2, SDL2_image, SDL2_mixer
, zlib, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "sauerbraten";
  version = "2020-12-04";

  src = fetchzip {
    url = "mirror://sourceforge/sauerbraten/sauerbraten_${builtins.replaceStrings [ "-" ] [ "_" ] version}_linux.tar.bz2";
    sha256 = "1hknwpnvsakz6s7l7j1r5aqmgrzp4wcbn8yg8nxmvsddbhxdj1kc";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    SDL2 SDL2_mixer SDL2_image
    zlib
  ];

  sourceRoot = "source/src";

  installPhase = ''
    mkdir -p $out/bin $out/share/sauerbraten $out/share/doc/sauerbraten
    cp -rv "../docs/"* $out/share/doc/sauerbraten/
    cp -v sauer_client sauer_server $out/share/sauerbraten/
    cp -rv ../packages ../data $out/share/sauerbraten/

    makeWrapper $out/share/sauerbraten/sauer_server $out/bin/sauerbraten_server \
      --run "cd $out/share/sauerbraten"
    makeWrapper $out/share/sauerbraten/sauer_client $out/bin/sauerbraten_client \
      --run "cd $out/share/sauerbraten" \
      --add-flags "-q\''${HOME}"
  '';

  meta = with stdenv.lib; {
    description = "A free multiplayer & singleplayer first person shooter, the successor of the Cube FPS";
    maintainers = with maintainers; [ raskin ajs124 ];
    hydraPlatforms =
      # raskin: tested amd64-linux;
      # not setting platforms because it is 0.5+ GiB of game data
      [];
    license = "freeware"; # as an aggregate - data files have different licenses
                          # code is under zlib license
    platforms = platforms.linux;
  };
}
