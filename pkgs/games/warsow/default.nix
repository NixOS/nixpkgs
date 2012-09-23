{ stdenv, fetchurl, unzip, pkgconfig, zlib, curl, libjpeg, libpng, libvorbis
, libtheora, libXxf86dga, libXxf86vm, libXinerama, SDL, mesa, openal
}:
stdenv.mkDerivation rec {
  name = "warsow-${version}";
  version = "1.0";
  mversion = "1.0";  # sometimes only engine is updated
  src1 = fetchurl {
    url = "http://www.warsow.net/download?dl=sdk";
    name = "warsow_${version}_sdk.tar.gz";
    sha256 = "08hfhx3ggb8v8lsb62ki5rhdhscg8j9sndlnllinf85da1f4nf9f";
  };
  src2 = fetchurl {
    url = "http://www.warsow.net/download?dl=linux";
    name = "warsow_${mversion}_unified.tar.gz";
    sha256 = "1v455v4lpqda7lf2yviasdrlibvb6bsyxcadgl8bd4jcvr8x4czr";
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
