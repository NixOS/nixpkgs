{ fetchurl, stdenv, unrar, unzip, SDL, SDL_image, SDL_ttf, SDL_mixer
, libmysql, makeWrapper }:

stdenv.mkDerivation rec {
  name = "zod-engine-2011-03-18";

  src = fetchurl {
    url = "mirror://sourceforge/zod/zod_src-2011-03-18.zip";
    sha256 = "00ny7a1yfn9zgl7q1ys27qafwc92dzxv07wjxl8nxa4f98al2g4n";
  };

  srcAssets = fetchurl {
    url = "mirror://sourceforge/zod/zod_assets-2011-03-12.rar";
    sha256 = "0gmg4ppr4y6ck04mandlp2fmdcyssmck999m012jx5v1rm57g2hn";
  };

  unpackPhase = ''
    mkdir src
    pushd src
    unzip $src
    popd
    sourceRoot=`pwd`/src
  '';

  buildInputs = [ unrar unzip SDL SDL_image SDL_ttf SDL_mixer libmysql
    makeWrapper ];

  NIX_LDFLAGS="-L${stdenv.lib.getLib libmysql}/lib/mysql";

  installPhase = ''
    mkdir -p $out/bin $out/share/zod
    pushd $out/share/zod
    unrar x $srcAssets
    popd
    cp zod $out/bin
    wrapProgram $out/bin/zod --run "cd $out/share/zod"
  '';

  meta = {
    description = "Multiplayer remake of ZED";
    homepage = http://zod.sourceforge.net/;
    license = stdenv.lib.licenses.gpl3Plus; /* Says the web */
  };
}
