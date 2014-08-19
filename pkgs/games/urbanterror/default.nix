{ stdenv, fetchurl, unzip, SDL, mesa, openal, curl }:
stdenv.mkDerivation rec {
  name = "urbanterror-${version}";
  version = "4.2.018";
  srcs =
    [ (fetchurl {
         url = "http://mirror.urtstats.net/urbanterror/UrbanTerror42_full018.zip";
         sha256 = "10710c5b762687a75a7abd3cc56de005ce12dcb7ac14c08f40bcb4e9d96f4e83";
       })
      (fetchurl {
         url = "https://github.com/Barbatos/ioq3-for-UrbanTerror-4/archive/release-4.2.018.tar.gz";
         sha256 = "c1fb3eb3a1e526247352b1c6abb5432b8a9b8730731ef917e4e5d21a152fb494";
       })
    ];
  buildInputs = [ unzip SDL mesa openal curl ];
  sourceRoot = "ioq3-for-UrbanTerror-4-release-4.2.018";
  configurePhase = ''
    echo "USE_OPENAL = 1" > Makefile.local
    echo "USE_OPENAL_DLOPEN = 0" >> Makefile.local
    echo "USE_CURL = 1" >> Makefile.local
    echo "USE_CURL_DLOPEN = 0" >> Makefile.local
  '';
  installPhase = ''
    destDir="$out/opt/urbanterror"
    mkdir -p "$destDir"
    mkdir -p "$out/bin"
    cp -v build/release-linux-*/Quake3-UrT.* \
          "$destDir/Quake3-UrT"
    cp -v build/release-linux-*/Quake3-UrT-Ded.* \
          "$destDir/Quake3-UrT-Ded"
    cp -rv ../UrbanTerror42/q3ut4 "$destDir"
    cat << EOF > "$out/bin/urbanterror"
    #! ${stdenv.shell}
    cd "$destDir"
    exec ./Quake3-UrT "\$@"
    EOF
    chmod +x "$out/bin/urbanterror"
    cat << EOF > "$out/bin/urbanterror-ded"
    #! ${stdenv.shell}
    cd "$destDir"
    exec ./Quake3-UrT-Ded "\$@"
    EOF
    chmod +x "$out/bin/urbanterror-ded"
  '';
  postFixup = ''
    p=$out/opt/urbanterror/Quake3-UrT
    cur_rpath=$(patchelf --print-rpath $p)
    patchelf --set-rpath $cur_rpath:${mesa}/lib $p
  '';
  meta = {
    description = "A multiplayer tactical FPS on top of Quake 3 engine";
    longDescription = ''
      Urban Terror is a free multiplayer first person shooter developed by
      FrozenSand, that (thanks to the ioquake3-code) does not require
      Quake III Arena anymore. Urban Terror can be described as a Hollywood
      tactical shooter; somewhat realism based, but the motto is "fun over
      realism". This results in a very unique, enjoyable and addictive game.
    '';
    homepage = http://www.urbanterror.net;
    license = [ "unfree-redistributable" ];
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
