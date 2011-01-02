{ stdenv, fetchurl, unzip, pkgconfig, zlib, curl, libjpeg, libvorbis
, libXxf86dga, libXxf86vm, libXinerama, SDL, mesa, openal
}:
stdenv.mkDerivation rec {
  name = "warsow-${version}";
  version = "0.6";
  src1 = fetchurl {
    url = "http://www.zcdn.org/dl/warsow_${version}_sdk.zip";
    sha256 = "1mrsr4af4wi04slc2f66rr467rxa15ppny7ms4gxhaqvvki5x3nq";
  };
  src2 = fetchurl {
    url = "http://www.zcdn.org/dl/warsow_${version}_unified.zip";
    sha256 = "0a4407kw86yvr411dd9m0dgp7wdkgd9j4ac32gfz6xprgplqkws3";
  };
  unpackPhase = ''
    mkdir warsow_${version}_sdk
    cd warsow_${version}_sdk
    unzip $src1
    cd source
    unzip $src2 'basewsw/*' -d release
  '';
  patchPhase = ''
    substituteInPlace snd_openal/snd_main.c --replace libopenal.so.1 ${openal}/lib/libopenal.so.1
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
