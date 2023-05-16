<<<<<<< HEAD
{ lib
, fetchzip
, stdenv
, copyDesktopItems
, imagemagick
, libicns
, makeBinaryWrapper
, curl
, libGL
, libGLU
, openal
, libXxf86vm
, SDL
, makeDesktopItem
}:

let
  version = "4.3.4";

  urbanterror-maps = fetchzip {
    name = "urbanterror-maps";
    url = "http://cdn.urbanterror.info/urt/43/releases/zips/UrbanTerror${builtins.replaceStrings ["."] [""] version}_full.zip";
    hash = "sha256-C6Gb5PPECAOjQhmkrzkV6dpY/zHVtUj9oq3507o2PUI=";
  };

  urbanterror-source = fetchzip {
    name = "urbanterror-source";
    url = "https://github.com/FrozenSand/ioq3-for-UrbanTerror-4/archive/release-${version}.zip";
    hash = "sha256-zF6Tkaj5WYkFU66VwpBFr1P18OJGrGgxnc/jvcvt8hA=";
  };
in
stdenv.mkDerivation {
  pname = "urbanterror";
  inherit version;

  srcs = [
    urbanterror-maps
    urbanterror-source
  ];

  sourceRoot = "urbanterror-source";

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
    libicns
    makeBinaryWrapper
  ];

  buildInputs = [
    curl
    libGL
    libGLU
    openal
    libXxf86vm
    SDL
  ];

  preConfigure = ''
    cp ${./Makefile.local} ./Makefile.local
  '';

  installTargets = [ "copyfiles" ];
  installFlags = [ "COPYDIR=$(out)/share/urbanterror" ];

  preInstall = ''
    mkdir -p $out/share/urbanterror
  '';

  postInstall = ''
    icns2png --extract ${urbanterror-maps}/Quake3-UrT.app/Contents/Resources/quake3-urt.icns

    for size in 16 24 32 48 64 128 256 512 1024; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      if [ ! -e quake3-urt_"$size"x"$size"x32.png ] ; then
        convert -resize "$size"x"$size" quake3-urt_512x512x32.png quake3-urt_"$size"x"$size"x32.png
      fi
      install -Dm644 quake3-urt_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/urbanterror.png
    done;

    makeWrapper $out/share/urbanterror/Quake3-UrT.* $out/bin/urbanterror
    makeWrapper $out/share/urbanterror/Quake3-UrT-Ded.* $out/bin/urbanterror-ded

    ln -s ${urbanterror-maps}/q3ut4 $out/share/urbanterror/
=======
{ lib, stdenv, fetchurl, unzip, SDL, libGLU, libGL, openal, curl, libXxf86vm }:

stdenv.mkDerivation rec {
  pname = "urbanterror";
  version = "4.3.4";

  srcs =
    [ (fetchurl {
         url = "http://cdn.urbanterror.info/urt/43/releases/zips/UrbanTerror434_full.zip";
         sha256 = "1rx4nnndsk88nvd7k4p35cw6znclkkzm2bl5j6vn6mjjdk66jrki";
       })
      (fetchurl {
         url = "https://github.com/FrozenSand/ioq3-for-UrbanTerror-4/archive/release-${version}.zip";
         sha256 = "1s9pmw7rbnzwzl1llcs0kr2krf4daf8hhnz1j89qk4bq9a9qfp71";
       })
    ];

  nativeBuildInputs = [ unzip ];
  buildInputs = [ SDL libGL libGLU openal curl libXxf86vm ];
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
    patchelf --set-rpath $cur_rpath:${libGL}/lib:${libGLU}/lib $p
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  hardeningDisable = [ "format" ];

<<<<<<< HEAD
  desktopItems = [
    (makeDesktopItem {
      name = "urbanterror";
      exec = "urbanterror";
      icon = "urbanterror";
      comment = "A multiplayer tactical FPS on top of Quake 3 engine";
      desktopName = "Urban Terror";
      categories = [ "Game" "ActionGame" ];
    })
  ];

  meta = {
    description = "A multiplayer tactical FPS on top of Quake 3 engine";
    homepage = "https://www.urbanterror.info";
    license = lib.licenses.unfreeRedistributable;
=======
  meta = with lib; {
    description = "A multiplayer tactical FPS on top of Quake 3 engine";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      Urban Terror is a free multiplayer first person shooter developed by
      FrozenSand, that (thanks to the ioquake3-code) does not require
      Quake III Arena anymore. Urban Terror can be described as a Hollywood
      tactical shooter; somewhat realism based, but the motto is "fun over
      realism". This results in a very unique, enjoyable and addictive game.
    '';
<<<<<<< HEAD
    mainProgram = "urbanterror";
    maintainers = with lib.maintainers; [ astsmtl drupol ];
    platforms = lib.platforms.linux;
=======
    homepage = "http://www.urbanterror.info";
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ astsmtl ];
    platforms = platforms.linux;
    hydraPlatforms = [];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
