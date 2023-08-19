{ lib, stdenv, fetchurl, unzip, SDL, libGLU, libGL, openal, curl, libXxf86vm, libicns, copyDesktopItems, makeDesktopItem }:

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

  nativeBuildInputs = [ unzip copyDesktopItems libicns ];
  buildInputs = [ SDL libGL libGLU openal curl libXxf86vm ];
  sourceRoot = "ioq3-for-UrbanTerror-4-release-${version}";

  configurePhase = ''
    runHook preConfigure

    echo "USE_OPENAL = 1" > Makefile.local
    echo "USE_OPENAL_DLOPEN = 0" >> Makefile.local
    echo "USE_CURL = 1" >> Makefile.local
    echo "USE_CURL_DLOPEN = 0" >> Makefile.local

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

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

    # Extract pngs from the Apple icon image and create
    # the missing ones from the 1024x1024 image.
    icns2png --extract ../UrbanTerror43/Quake3-UrT.app/Contents/Resources/quake3-urt.icns
    ls -la .
    for size in 16 32 128 256 512; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      install -Dm644 icon_"$size"x"$size"x32.png $out/share/icons/hicolor/"$size"x"$size"/apps/urbanterror.png
    done;

    runHook postInstall
  '';

  postFixup = ''
    p=$out/opt/urbanterror/Quake3-UrT
    cur_rpath=$(patchelf --print-rpath $p)
    patchelf --set-rpath $cur_rpath:${libGL}/lib:${libGLU}/lib $p
  '';

  hardeningDisable = [ "format" ];

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

  meta = with lib; {
    description = "A multiplayer tactical FPS on top of Quake 3 engine";
    longDescription = ''
      Urban Terror is a free multiplayer first person shooter developed by
      FrozenSand, that (thanks to the ioquake3-code) does not require
      Quake III Arena anymore. Urban Terror can be described as a Hollywood
      tactical shooter; somewhat realism based, but the motto is "fun over
      realism". This results in a very unique, enjoyable and addictive game.
    '';
    homepage = "http://www.urbanterror.info";
    license = licenses.unfreeRedistributable;
    mainProgram = "urbanterror";
    maintainers = with maintainers; [ astsmtl drupol ];
    platforms = platforms.linux;
    hydraPlatforms = [];
  };
}
