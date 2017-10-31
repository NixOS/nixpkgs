{ stdenv, fetchurl, unzip, pkgconfig, zlib, curl, libjpeg, libpng, libvorbis
, libtheora, libXxf86dga, libXxf86vm, libXinerama, SDL, mesa, openal, freetype
, makeWrapper
}:
stdenv.mkDerivation rec {
  name = "warsow-${version}";
  version = "1.03";
  mversion = "1.02";  # sometimes only engine is updated
  src1 = fetchurl {
    url = "http://www.warsow.net:1337/~warsow/${version}/warsow_${version}_sdk.tar.gz";
    sha256 = "0z6r5v30p8fxbszmkxssv5fnnjw7w5wfn7wfgbwvmy87ayi7mkcq";
  };
  src2 = fetchurl {
    url = "http://www.warsow.net:1337/~warsow/${mversion}/warsow_${mversion}.tar.gz";
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
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ unzip zlib curl libjpeg libpng libvorbis libtheora
                  libXxf86dga libXxf86vm libXinerama SDL mesa openal makeWrapper
                ];
  installPhase = ''
    dest=$out/opt/warsow
    cd release
    mkdir -p $dest
    mkdir -p $out/bin
    cp -v {warsow,wsw_server,wswtv_server}* $dest
    cp -rv basewsw libs $dest
    # Since 1.03 some modules are _always_ downloaded from server, thus
    makeWrapper $dest/warsow $out/bin/warsow \
      --suffix-each LD_LIBRARY_PATH ':' "${freetype.out}/lib"
    makeWrapper $dest/wsw_server $out/bin/wsw_server
    makeWrapper $dest/wswtv_server $out/bin/wswtv_server
  '';
  postFixup = ''
    p=$out/opt/warsow/warsow.*
    cur_rpath=$(patchelf --print-rpath $p)
    patchelf --set-rpath $cur_rpath:${mesa}/lib $p
  '';
  meta = with stdenv.lib; {
    description = "Multiplayer FPS game designed for competitive gaming";
    longDescription = ''
      Set in a futuristic cartoon-like world where rocketlauncher-wielding
      pigs and lasergun-carrying cyberpunks roam the streets, Warsow is a
      completely free fast-paced first-person shooter (FPS) for Windows, Linux
      and macOS.
    '';
    homepage = http://www.warsow.net;
    # Engine is under GPLv2, everything else is under
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
    broken = true; # Depends on a specific old libjpeg version
  };
}
