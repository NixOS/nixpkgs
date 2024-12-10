{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  makeWrapper,
  runCommand,
  makeDesktopItem,
  xonotic-data,
  copyDesktopItems,
  # required for both
  unzip,
  libjpeg,
  zlib,
  libvorbis,
  curl,
  freetype,
  libpng,
  libtheora,
  # glx
  libX11,
  libGLU,
  libGL,
  libXpm,
  libXext,
  libXxf86vm,
  alsa-lib,
  # sdl
  SDL2,
  # blind
  gmp,

  withSDL ? true,
  withGLX ? false,
  withDedicated ? true,
}:

let
  pname = "xonotic";
  version = "0.8.6";
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
    else
      "-what-even-am-i";

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
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      astsmtl
      zalakain
    ];
    platforms = lib.platforms.linux;
  };

  desktopItem = makeDesktopItem {
    name = "xonotic";
    exec = "xonotic";
    comment = meta.description;
    desktopName = "Xonotic";
    categories = [
      "Game"
      "Shooter"
    ];
    icon = "xonotic";
    startupNotify = false;
  };

  xonotic-unwrapped = stdenv.mkDerivation rec {
    pname = "xonotic${variant}-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://dl.xonotic.org/xonotic-${version}-source.zip";
      hash = "sha256-i5KseBz/SuicEhoj6s197AWiqr7azMI6GdGglYtAEqg=";
    };

    nativeBuildInputs = [ unzip ];
    buildInputs =
      [
        libjpeg
        zlib
        libvorbis
        curl
        gmp
      ]
      ++ lib.optionals withGLX [
        libX11
        libGLU
        libGL
        libXpm
        libXext
        libXxf86vm
        alsa-lib
      ]
      ++ lib.optionals withSDL [ SDL2 ];

    sourceRoot = "Xonotic/source/darkplaces";

    # "debug", "release", "profile"
    target = "release";

    dontStrip = target != "release";

    postConfigure = ''
      pushd ../d0_blind_id
      ./configure $configureFlags
      popd
    '';

    buildPhase =
      (
        lib.optionalString withDedicated ''
          make -j $NIX_BUILD_CORES sv-${target}
        ''
        + lib.optionalString withGLX ''
          make -j $NIX_BUILD_CORES cl-${target}
        ''
        + lib.optionalString withSDL ''
          make -j $NIX_BUILD_CORES sdl-${target}
        ''
      )
      + ''
        pushd ../d0_blind_id
        make -j $NIX_BUILD_CORES
        popd
      '';

    enableParallelBuilding = true;

    installPhase =
      (
        ''
          install -Dm644 ../../misc/logos/xonotic_icon.svg \
            $out/share/icons/hicolor/scalable/apps/xonotic.svg
          pushd ../../misc/logos/icons_png
          for img in *.png; do
            size=''${img#xonotic_}
            size=''${size%.png}
            dimensions="''${size}x''${size}"
            install -Dm644 $img \
              $out/share/icons/hicolor/$dimensions/apps/xonotic.png
          done
          popd
        ''
        + lib.optionalString withDedicated ''
          install -Dm755 darkplaces-dedicated "$out/bin/xonotic-dedicated"
        ''
        + lib.optionalString withGLX ''
          install -Dm755 darkplaces-glx "$out/bin/xonotic-glx"
        ''
        + lib.optionalString withSDL ''
          install -Dm755 darkplaces-sdl "$out/bin/xonotic-sdl"
        ''
      )
      + ''
        pushd ../d0_blind_id
        make install
        popd
      '';

    # Xonotic needs to find libcurl.so at runtime for map downloads
    dontPatchELF = true;
    postFixup =
      lib.optionalString withDedicated ''
        patchelf --add-needed ${curl.out}/lib/libcurl.so $out/bin/xonotic-dedicated
      ''
      + lib.optionalString withGLX ''
        patchelf \
            --add-needed ${curl.out}/lib/libcurl.so \
            --add-needed ${libvorbis}/lib/libvorbisfile.so \
            --add-needed ${libvorbis}/lib/libvorbisenc.so \
            --add-needed ${libvorbis}/lib/libvorbis.so \
            --add-needed ${libGL.out}/lib/libGL.so \
            --add-needed ${freetype}/lib/libfreetype.so \
            --add-needed ${libpng}/lib/libpng.so \
            --add-needed ${libtheora}/lib/libtheora.so \
            $out/bin/xonotic-glx
      ''
      + lib.optionalString withSDL ''
        patchelf \
            --add-needed ${curl.out}/lib/libcurl.so \
            --add-needed ${libvorbis}/lib/libvorbisfile.so \
            --add-needed ${libvorbis}/lib/libvorbisenc.so \
            --add-needed ${libvorbis}/lib/libvorbis.so \
            --add-needed ${freetype}/lib/libfreetype.so \
            --add-needed ${libpng}/lib/libpng.so \
            --add-needed ${libtheora}/lib/libtheora.so \
            $out/bin/xonotic-sdl
      '';
  };

in
rec {
  xonotic-data = fetchzip {
    name = "xonotic-data";
    url = "https://dl.xonotic.org/xonotic-${version}.zip";
    hash = "sha256-Lhjpyk7idmfQAVn4YUb7diGyyKZQBfwNXxk2zMOqiZQ=";
    postFetch = ''
      cd $out
      rm -rf $(ls | grep -v "^data$" | grep -v "^key_0.d0pk$")
    '';
    meta.hydraPlatforms = [ ];
    passthru.version = version;
  };

  xonotic =
    runCommand "xonotic${variant}-${version}"
      {
        inherit xonotic-unwrapped;
        nativeBuildInputs = [
          makeWrapper
          copyDesktopItems
        ];
        desktopItems = [ desktopItem ];
        passthru = {
          inherit version;
          meta = meta // {
            hydraPlatforms = [ ];
          };
        };
      }
      (
        ''
          mkdir -p $out/bin
        ''
        + lib.optionalString withDedicated ''
          ln -s ${xonotic-unwrapped}/bin/xonotic-dedicated $out/bin/
        ''
        + lib.optionalString withGLX ''
          ln -s ${xonotic-unwrapped}/bin/xonotic-glx $out/bin/xonotic-glx
          ln -s $out/bin/xonotic-glx $out/bin/xonotic
        ''
        + lib.optionalString withSDL ''
          ln -s ${xonotic-unwrapped}/bin/xonotic-sdl $out/bin/xonotic-sdl
          ln -sf $out/bin/xonotic-sdl $out/bin/xonotic
        ''
        + lib.optionalString (withSDL || withGLX) ''
          mkdir -p $out/share
          ln -s ${xonotic-unwrapped}/share/icons $out/share/icons
          copyDesktopItems
        ''
        + ''
          for binary in $out/bin/xonotic-*; do
            wrapProgram $binary --add-flags "-basedir ${xonotic-data}" --prefix LD_LIBRARY_PATH : "${xonotic-unwrapped}/lib"
          done
        ''
      );
}
