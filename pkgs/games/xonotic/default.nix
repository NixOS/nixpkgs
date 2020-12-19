{ lib, stdenv, fetchurl, fetchzip, makeWrapper, runCommandNoCC, makeDesktopItem
, xonotic-data, copyDesktopItems
, # required for both
  unzip, libjpeg, zlib, libvorbis, curl
, # glx
  libX11, libGLU, libGL, libXpm, libXext, libXxf86vm, alsaLib
, # sdl
  SDL2

, withSDL ? true
, withGLX ? false
, withDedicated ? true
}:

let
  pname = "xonotic";
  version = "0.8.2";
  name = "${pname}-${version}";
  variant =
    if withSDL && withGLX then
      ""
    else if withSDL then
      "-sdl"
    else if withGLX then
      "-glx"
    else if withDedicated then
      "-dedicated"
    else "-what-even-am-i";

  meta = {
    description = "A free fast-paced first-person shooter";
    longDescription = ''
      Xonotic is a free, fast-paced first-person shooter that works on
      Windows, macOS and Linux. The project is geared towards providing
      addictive arena shooter gameplay which is all spawned and driven
      by the community itself. Xonotic is a direct successor of the
      Nexuiz project with years of development between them, and it
      aims to become the best possible open-source FPS of its kind.
    '';
    homepage = "https://www.xonotic.org/";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ astsmtl zalakain petabyteboy ];
    platforms = stdenv.lib.platforms.linux;
  };

  desktopItem = makeDesktopItem {
    name = "xonotic";
    exec = "xonotic";
    comment = meta.description;
    desktopName = "Xonotic";
    categories = "Game;Shooter;";
    icon = "xonotic";
    startupNotify = "false";
  };

  xonotic-unwrapped = stdenv.mkDerivation rec {
    pname = "xonotic${variant}-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://dl.xonotic.org/${name}-source.zip";
      sha256 = "0axxw04fyz6jlfqd0kp7hdrqa0li31sx1pbipf2j5qp9wvqicsay";
    };

    buildInputs = [ unzip libjpeg zlib libvorbis curl ]
      ++ lib.optional withGLX [ libX11.dev libGLU.dev libGL.dev libXpm.dev libXext.dev libXxf86vm.dev alsaLib.dev ]
      ++ lib.optional withSDL [ SDL2.dev ];

    sourceRoot = "Xonotic/source/darkplaces";

    # "debug", "release", "profile"
    target = "release";

    dontStrip = target != "release";

    buildPhase = lib.optionalString withDedicated ''
      make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES sv-${target}
    '' + lib.optionalString withGLX ''
      make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES cl-${target}
    '' + lib.optionalString withSDL ''
      make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES sdl-${target}
    '';

    enableParallelBuilding = true;

    installPhase = ''
      for size in 16x16 24x24 32x32 48x48 64x64 72x72 96x96 128x128 192x192 256x256 512x512 1024x1024 scalable; do
        install -Dm644 ../../misc/logos/xonotic_icon.svg \
          $out/share/icons/hicolor/$size/xonotic.svg
      done
    '' + lib.optionalString withDedicated ''
      install -Dm755 darkplaces-dedicated "$out/bin/xonotic-dedicated"
    '' + lib.optionalString withGLX ''
      install -Dm755 darkplaces-glx "$out/bin/xonotic-glx"
    '' + lib.optionalString withSDL ''
      install -Dm755 darkplaces-sdl "$out/bin/xonotic-sdl"
    '';

    # Xonotic needs to find libcurl.so at runtime for map downloads
    dontPatchELF = true;
    postFixup = lib.optionalString withDedicated ''
      patchelf --add-needed ${curl.out}/lib/libcurl.so $out/bin/xonotic-dedicated
    '' + lib.optionalString withGLX ''
      patchelf \
          --add-needed ${curl.out}/lib/libcurl.so \
          --add-needed ${libvorbis}/lib/libvorbisfile.so \
          --add-needed ${libvorbis}/lib/libvorbis.so \
          --add-needed ${libGL.out}/lib/libGL.so \
          $out/bin/xonotic-glx
    '' + lib.optionalString withSDL ''
      patchelf \
          --add-needed ${curl.out}/lib/libcurl.so \
          --add-needed ${libvorbis}/lib/libvorbisfile.so \
          --add-needed ${libvorbis}/lib/libvorbis.so \
          $out/bin/xonotic-sdl
    '';
  };

in rec {
  xonotic-data = fetchzip {
    name = "xonotic-data-${version}";
    url = "https://dl.xonotic.org/${name}.zip";
    sha256 = "1ygkh0v68y4sd1w5vpk8dgb65h5jm599hwszdfgjp3ax4d3ml81x";
    extraPostFetch = ''
      cd $out
      rm -rf $(ls | grep -v "^data$")
    '';
    meta.hydraPlatforms = [];
    passthru.version = version;
  };

  xonotic = runCommandNoCC "xonotic${variant}-${version}" {
    inherit xonotic-unwrapped;
    nativeBuildInputs = [ makeWrapper copyDesktopItems ];
    desktopItems = [ desktopItem ];
    passthru = {
      inherit version;
      meta = meta // {
        hydraPlatforms = [];
      };
    };
  } (''
    mkdir -p $out/bin
  '' + lib.optionalString withDedicated ''
    ln -s ${xonotic-unwrapped}/bin/xonotic-dedicated $out/bin/
  '' + lib.optionalString withGLX ''
    ln -s ${xonotic-unwrapped}/bin/xonotic-glx $out/bin/xonotic-glx
    ln -s $out/bin/xonotic-glx $out/bin/xonotic
  '' + lib.optionalString withSDL ''
    ln -s ${xonotic-unwrapped}/bin/xonotic-sdl $out/bin/xonotic-sdl
    ln -sf $out/bin/xonotic-sdl $out/bin/xonotic
  '' + lib.optionalString (withSDL || withGLX) ''
    mkdir -p $out/share
    ln -s ${xonotic-unwrapped}/share/icons $out/share/icons
    copyDesktopItems
  '' + ''
    for binary in $out/bin/xonotic-*; do
      wrapProgram $binary --add-flags "-basedir ${xonotic-data}"
    done
  '');
}
