{ stdenv, fetchurl, unzip, pkgconfig, zlib, curl, libjpeg, libvorbis
, libXxf86dga, libXxf86vm, libXinerama, SDL, mesa, openal
}:
stdenv.mkDerivation rec {
  name = "warsow-${version}";
  version = "0.5";
  src1 = fetchurl {
    url = "http://static.warsow.net/release/warsow_${version}_sdk.zip";
    sha256 = "018z83irj6wr5mj4pnya1r4abmg9sqznnkyq0gw9sr9q9dxr7k1m";
  };
  src2 = fetchurl {
    url = "http://static.warsow.net/release/warsow_${version}_unified.zip";
    sha256 = "002idzqjq41ygjny9kk31fjx7l9clxy4xm38hc5dky6yfx17ib36";
  };
  unpackPhase = ''
    mkdir warsow_${version}_sdk
    cd warsow_${version}_sdk
    unzip $src1
    cd source
    unzip $src2 'basewsw/*' -d release
  '';
  patchPhase = ''
    substituteInPlace Makefile --replace openal-config 'pkg-config openal'
    substituteInPlace snd_openal/snd_main.c --replace libopenal.so.0 ${openal}/lib/libopenal.so
  '';
  buildInputs = [ unzip pkgconfig zlib curl libjpeg libvorbis libXxf86dga
                  libXxf86vm libXinerama SDL mesa openal ];
  installPhase = ''
    dest=$out/opt/warsow
    cd release
    for f in warsow wsw_server wswtv_server; do
        substituteInPlace $f --replace BINARY_DIR= BINARY_DIR=$dest
    done
    ensureDir $dest
    ensureDir $out/bin
    cp -v {warsow,wsw_server,wswtv_server}.* $dest
    cp -rv basewsw libs $dest
    cp -v warsow wsw_server wswtv_server $out/bin
  '';
  postFixup = ''
    p=$out/opt/warsow/warsow.*
    cur_rpath=$(patchelf --print-rpath $p)
    patchelf --set-rpath $cur_rpath:${mesa}/lib $p
  '';
  meta = {
    description = "A multiplayer FPS designed for competitive gaming.";
    longDescription = ''
      Set in a futuristic cartoon-like world where rocketlauncher-wielding
      pigs and lasergun-carrying cyberpunks roam the streets, Warsow is a
      completely free fast-paced first-person shooter (FPS) for Windows, Linux
      and Mac OS X.
    '';
    homepage = http://www.warsow.net;
    # Engine is under GPLv2, everything else is under
    license = [ "unfree-redistributable" ];
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
