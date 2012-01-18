{ stdenv, fetchurl, unzip, pkgconfig, zlib, curl, libjpeg, libvorbis
, libXxf86dga, libXxf86vm, libXinerama, SDL, mesa, openal
}:
stdenv.mkDerivation rec {
  name = "warsow-${version}";
  version = "0.62";
  mversion = "0.61";  # sometimes only engine is updated
  src1 = fetchurl {
    url = "http://www.zcdn.org/dl/warsow_${version}_sdk.zip";
    sha256 = "0nb1z55lzmwarnn71dcyg9b3k7r7wxagqxks8a7rnlq7acsnra71";
  };
  src2 = fetchurl {
    url = "http://www.zcdn.org/dl/warsow_${mversion}_unified.zip";
    sha256 = "1b5bv4dsly7i7c4fqlkckv4da1knxl9m3kg8nlgkgr8waczgvazv";
  };
  unpackPhase = ''
    mkdir warsow_${version}_sdk
    cd warsow_${version}_sdk
    unzip $src1
    unzip $src2
    mkdir -p source/release/
    mv warsow_${mversion}_unified/basewsw source/release/
    cd source
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
