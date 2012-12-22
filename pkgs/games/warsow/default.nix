{ stdenv, fetchurl, unzip, pkgconfig, zlib, curl, libjpeg, libpng, libvorbis
, libtheora, libXxf86dga, libXxf86vm, libXinerama, SDL, mesa, openal
}:
stdenv.mkDerivation rec {
  name = "warsow-${version}";
  version = "1.02";
  mversion = "1.02";  # sometimes only engine is updated
  src1 = fetchurl {
    url = "http://www.warsow.net:1337/~warsow/1.02/warsow_1.02_sdk.tar.gz";
    sha256 = "0b5vra4qihkkcw4jn54r8l2lyl2mp67b4y1m76nyz7f34vng1hdy";
  };
  src2 = fetchurl {
    url = "http://www.warsow.net:1337/~warsow/1.02/warsow_1.02.tar.gz";
    sha256 = "0ai5v1h5g9nq21ixz23v0qsj9dr7dbiz7l8r34mq4c3z6ili8zpy";
  };
  unpackPhase = ''
    tar xf "$src1"
    cd warsow_${version}_sdk
    tar xf "$src2"
    mkdir -p source/release/
    mv warsow_${mversion}/basewsw source/release/
    cd source
  '';
  patchPhase = ''
    substituteInPlace snd_openal/snd_main.c --replace libopenal.so.1 ${openal}/lib/libopenal.so.1
  '';
  buildInputs = [ unzip pkgconfig zlib curl libjpeg libpng libvorbis libtheora
                  libXxf86dga libXxf86vm libXinerama SDL mesa openal ];
  installPhase = ''
    dest=$out/opt/warsow
    cd release
    for f in warsow wsw_server wswtv_server; do
        substituteInPlace $f --replace BINARY_DIR= BINARY_DIR=$dest
    done
    mkdir -p $dest
    mkdir -p $out/bin
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
