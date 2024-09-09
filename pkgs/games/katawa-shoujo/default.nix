{ stdenvNoCC
, lib
, fetchurl
, autoPatchelfHook
, copyDesktopItems
, freetype
, makeDesktopItem
, makeWrapper
, libGL
, libGLU
# Darwin cannot handle these when devendored:
# - DYLD_LIBRARY_PATH masks system libraries with similar, differently-cased names and cause missing symbol errors
# - symlinks cause unrelated BMP image loading to fail(?)
, devendorImageLibs ? !stdenvNoCC.hostPlatform.isDarwin
, libjpeg
, libpng12
, libX11
, libXext
, libXi
, libXmu
, runtimeShell
, SDL_compat
, SDL_image
, SDL_ttf
, undmg
, unrpa
, zlib
}:

let
  stdenv = stdenvNoCC;
  srcDetails = rec {
    x86_64-linux = {
      urlSuffix = "%5blinux-x86%5d%5b18161880%5d.tar.bz2";
      hash = "sha256-7FoFz88dWYHs2/pxkEwnmiFeeb3+slayrWknEJoAB9o=";
    };
    i686-linux = x86_64-linux;
    x86_64-darwin = {
      urlSuffix = "%5bmac%5d%5b1DFC84A6%5d.dmg";
      hash = "sha256-Sc5BAlpJsffjcNrZ8+VU3n7G10DoqDKQn/leHDW32Y8=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Don't know how to fetch source for ${stdenv.hostPlatform.system}!");
in
stdenv.mkDerivation rec {
  pname = "katawa-shoujo";
  version = "1.3.1";

  src = fetchurl {
    url = "https://cdn.fhs.sh/ks/bin/gold_${version}/%5b4ls%5d_katawa_shoujo_${version}-${srcDetails.urlSuffix}";
    inherit (srcDetails) hash;
  };

  # fetchzip requires a custom unpackPhase to handle dmg, fetchurl cannot handle undmg producing >1 directory without this
  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
    unrpa
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeWrapper
    undmg
  ];

  buildInputs = [
    freetype
    SDL_compat
    zlib
  ] ++ lib.optionals devendorImageLibs [
    libjpeg
    libpng12
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    libX11
    libXext
    libXi
    libXmu
    libGL
    libGLU
  ];

  desktopItems = [(makeDesktopItem rec {
    name = "katawa-shoujo";
    desktopName = "Katawa Shoujo";
    comment = meta.description;
    exec = name;
    icon = name;
    categories = [ "Game" ];
  })];

  dontConfigure = true;
  dontBuild = true;

  installPhase = let
    platformDetails = with stdenv.hostPlatform; if isDarwin then rec {
      arch = "darwin-x86_64";
      sourceDir = "'Katawa Shoujo'.app";
      installDir = "$out/Applications/'Katawa Shoujo'.app";
      dataDir = "${installDir}/Contents/Resources/autorun";
      bin = "${installDir}/Contents/MacOS/'Katawa Shoujo'";
    } else rec {
      arch = "linux-${if isx86_64 then "x86_64" else "i686"}";
      sourceDir = "'Katawa Shoujo'-${version}-linux";
      installDir = "$out/share/katawa-shoujo";
      dataDir = installDir;
      bin = "${installDir}/'Katawa Shoujo'.sh";
    };
    libDir = with platformDetails; "${dataDir}/lib/${arch}";
  in with platformDetails; ''
    runHook preInstall

    mkdir -p "$(dirname ${installDir})"
    cp -R ${sourceDir} ${installDir}

    # Simplify launcher script
    cat <<EOF >${bin}
    #!${runtimeShell}
    exec \$RENPY_GDB ${libDir}/'Katawa Shoujo' \$RENPY_PYARGS -EO ${dataDir}/'Katawa Shoujo'.py "\$@"
    EOF

  '' + (if stdenv.hostPlatform.isDarwin then ''
    # No autoPatchelfHook on Darwin
    wrapProgram ${bin} \
      --prefix DYLD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}
  '' else ''
    # Extract icon for xdg desktop file
    unrpa ${dataDir}/game/data.rpa
    install -Dm644 ui/icon.png $out/share/icons/hicolor/512x512/apps/katawa-shoujo.png
  '') + ''

    # Delete binaries for wrong arch, autoPatchelfHook gets confused by them & less to keep in the store
    find "$(dirname ${libDir})" -mindepth 1 -maxdepth 1 \
      -not -name 'python*' -not -name ${arch} \
      -exec rm -r {} \;

    # Replace some bundled libs so Nixpkgs' versions are used
    rm ${libDir}/libz*
    rm ${libDir}/libfreetype*
    rm ${libDir}/libSDL-1.2*
  '' + lib.optionalString devendorImageLibs ''
    rm ${libDir}/libjpeg*
    rm ${libDir}/libpng12*
  '' + ''

    mkdir -p $out/share/{doc,licenses}/katawa-shoujo
    mv ${dataDir}/'Game Manual'.pdf $out/share/doc/katawa-shoujo/
    mv ${dataDir}/LICENSE.txt $out/share/licenses/katawa-shoujo/

    mkdir -p $out/bin
    ln -s ${bin} $out/bin/katawa-shoujo

    runHook postInstall
  '';

  meta = with lib; {
    description = "Bishoujo-style visual novel by Four Leaf Studios, built in Ren'Py";
    longDescription = ''
      Katawa Shoujo is a bishoujo-style visual novel set in the fictional Yamaku High School for disabled children,
      located somewhere in modern Japan. Hisao Nakai, a normal boy living a normal life, has his life turned upside down
      when a congenital heart defect forces him to move to a new school after a long hospitalization. Despite his difficulties,
      Hisao is able to find friends—and perhaps love, if he plays his cards right. There are five main paths corresponding
      to the 5 main female characters, each path following the storyline pertaining to that character.

      The story is told through the perspective of the main character, using a first person narrative. The game uses a
      traditional text and sprite-based visual novel model with an ADV text box.

      Katawa Shoujo contains adult material, and was created using the Ren'Py scripting system. It is the product of an
      international team of amateur developers, and is available free of charge under the Creative Commons BY-NC-ND License.
    '';
    homepage = "https://www.katawa-shoujo.com/";
    # https://www.katawa-shoujo.com/about.php
    # November 2022: Update, is it still ND?
    # https://ks.renai.us/viewtopic.php?f=13&p=248149#p248149
    license = with licenses; [ cc-by-nc-nd-30 ];
    maintainers = with maintainers; [ OPNA2608 ];
    # Building Ren'Py6 from source would allow more, but too much of a hassle
    platforms = platforms.x86;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # Needs different srcDetails & installPhase
    broken = stdenv.hostPlatform.isWindows;
  };
}
