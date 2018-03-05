{ stdenv, fetchurl, scons, pkgconfig
, SDL, SDL_mixer, libGLU_combined, physfs
}:

let
  music = fetchurl {
    url = "http://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.dxa";
    sha256 = "05mz77vml396mff43dbs50524rlm4fyds6widypagfbh5hc55qdc";
  };

in stdenv.mkDerivation rec {
  name = "dxx-rebirth-${version}";
  version = "0.59.100";

  src = fetchurl {
    url = "http://www.dxx-rebirth.com/download/dxx/dxx-rebirth_v${version}-src.tar.gz";
    sha256 = "0m9k34zyr8bbni9szip407mffdpwbqszgfggavgqjwq0k9c1w7ka";
  };

  nativeBuildInputs = [ pkgconfig scons ];

  buildInputs = [ libGLU_combined physfs SDL SDL_mixer ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    scons prefix=$out install
    install -Dm644 ${music} $out/share/games/dxx-rebirth/d2xr-sc55-music.dxa
    install -Dm644 -t $out/share/doc/dxx-rebirth *.txt

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Source Port of the Descent 1 and 2 engines";
    homepage = http://www.dxx-rebirth.com/;
    license = licenses.free;
    maintainers = with maintainers; [ viric ];
    platforms = with platforms; linux;
  };
}
