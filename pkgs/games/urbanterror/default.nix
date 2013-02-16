{ stdenv, fetchurl, unzip, SDL, mesa, openal, curl }:
stdenv.mkDerivation rec {
  name = "urbanterror-${version}";
  version = "4.2.009";
  srcs =
    [ (fetchurl {
         url = "http://download.urbanterror.info/urt/42/zips/UrbanTerror42_full_009.zip";
         sha256 = "0m423zy6l1z4kxz55knlh1ypnqq58ghh08i8ziv4lm00ygm6mx2i";
       })
      (fetchurl {
         url = "https://github.com/Barbatos/ioq3-for-UrbanTerror-4/archive/release-4.2.007.tar.gz";
         sha256 = "1299j0i94697m2bbcgraxfbb7q1g6nc43l1xqlgqvcsjp799mwwn";
       })
    ];
  buildInputs = [ unzip SDL mesa openal curl ];
  sourceRoot = "ioq3-for-UrbanTerror-4-release-4.2.007";
  configurePhase = ''
    echo "USE_OPENAL = 1" > Makefile.local
    echo "USE_OPENAL_DLOPEN = 0" >> Makefile.local
    echo "USE_CURL = 1" >> Makefile.local
    echo "USE_CURL_DLOPEN = 0" >> Makefile.local
  '';
  installPhase = ''
    destDir="$out/opt/urbanterror"
    ensureDir "$destDir" "$out/bin"
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
    #platforms = stdenv.lib.platforms.linux;
  };
}
