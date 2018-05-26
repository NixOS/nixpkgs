{ stdenv, fetchurl, fetchpatch, scons, pkgconfig
, SDL, SDL_mixer, libGLU_combined, physfs
}:

let
  music = fetchurl {
    url = "https://www.dxx-rebirth.com/download/dxx/res/d2xr-sc55-music.dxa";
    sha256 = "05mz77vml396mff43dbs50524rlm4fyds6widypagfbh5hc55qdc";
  };

in stdenv.mkDerivation rec {
  name = "dxx-rebirth-${version}";
  version = "0.59.100";

  src = fetchurl {
    url = "https://www.dxx-rebirth.com/download/dxx/dxx-rebirth_v${version}-src.tar.gz";
    sha256 = "0m9k34zyr8bbni9szip407mffdpwbqszgfggavgqjwq0k9c1w7ka";
  };

  # TODO: drop these when upgrading to version > 0.59.100
  patches = [
    (fetchpatch {
      name   = "dxx-gcc7-fix1.patch";
      url    = "https://github.com/dxx-rebirth/dxx-rebirth/commit/1ed7cec714c623758e3418ec69eaf3b3ff03e9f6.patch";
      sha256 = "026pn8xglmxryaj8555h5rhzkx30lxmksja1fzdlfyb1vll75gq0";
    })
    (fetchpatch {
      name   = "dxx-gcc7-fix2.patch";
      url    = "https://github.com/dxx-rebirth/dxx-rebirth/commit/73057ad8ec6977ac747637db1080686f11b4c3cc.patch";
      sha256 = "0s506vdd2djrrm3xl0ygn9ylpg6y8qxii2nnzk3sf9133glp3swy";
    })
  ];

  nativeBuildInputs = [ pkgconfig scons ];

  buildInputs = [ libGLU_combined physfs SDL SDL_mixer ];

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    scons prefix=$out

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    scons prefix=$out install
    install -Dm644 ${music} $out/share/games/dxx-rebirth/d2xr-sc55-music.dxa
    install -Dm644 -t $out/share/doc/dxx-rebirth *.txt

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Source Port of the Descent 1 and 2 engines";
    homepage = https://www.dxx-rebirth.com/;
    license = licenses.free;
    maintainers = with maintainers; [ viric peterhoeg ];
    platforms = with platforms; linux;
  };
}
