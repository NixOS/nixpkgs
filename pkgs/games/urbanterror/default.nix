{ stdenv, fetchurl, unzip, SDL, mesa, openal, curl, libXxf86vm }:

stdenv.mkDerivation rec {
  name = "urbanterror-${version}";
  version = "4.3.2";

  srcs =
    [ (fetchurl {
         url = "http://cdn.fs1.urbanterror.info/urt/43/releases/zips/UrbanTerror432_full.zip";
         sha256 = "192jwdyfy18cg413ysaklqc8yzmdnshljqc6dnr0xkd6dxbf3pkl";
       })
      (fetchurl {
         url = "https://github.com/Barbatos/ioq3-for-UrbanTerror-4/archive/release-${version}.zip";
         sha256 = "0m376hdkk8vjnbdy8zakjazyag6jiw4n8zy4lxhv2ndn9mii8lcx";
       })
    ];

  buildInputs = [ unzip SDL mesa openal curl libXxf86vm ];
  sourceRoot = "ioq3-for-UrbanTerror-4-release-${version}";

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
    cp -rv ../UrbanTerror43/q3ut4 "$destDir"
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

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "A multiplayer tactical FPS on top of Quake 3 engine";
    longDescription = ''
      Urban Terror is a free multiplayer first person shooter developed by
      FrozenSand, that (thanks to the ioquake3-code) does not require
      Quake III Arena anymore. Urban Terror can be described as a Hollywood
      tactical shooter; somewhat realism based, but the motto is "fun over
      realism". This results in a very unique, enjoyable and addictive game.
    '';
    homepage = http://www.urbanterror.net;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
