{ lib
, stdenv
, fetchFromGitLab
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, wrapQtAppsHook
, SDL2
, CoreMedia
, VideoToolbox
, VideoDecodeAcceleration
, boost
, bullet
, ffmpeg
, libXt
, luajit
, lz4
, mygui
, openal
, openscenegraph
, recastnavigation
, unshield
, yaml-cpp
}:

let
  GL = "GLVND"; # or "LEGACY";

  osg' = (openscenegraph.override { colladaSupport = true; }).overrideDerivation (old: {
    version = "openmw-unstable-01-07-2024";
    # A dev recommended using the latest 3.6 branch. Seems to work well and fix a bug related to collada
    # randomly not loading compared to the one referenced in the flatpak build script.
    src = fetchFromGitHub {
      owner = "openmw";
      repo = "osg";
      rev = "43faf6fa88bd236e0911a5340bfbcbc25b3a98d9";
      sha256 = "sha256-P/959OYW9F3hjgo3QdjVfNuCzS8e7y7oxpVj4Kcl1X4=";
    };
    patches = [
      (fetchpatch {
        # Darwin: Without this patch, OSG won't build osgdb_png.so, which is required by OpenMW.
        name = "darwin-osg-plugins-fix.patch";
        url = "https://gitlab.com/OpenMW/openmw-dep/-/raw/1305497c009dc0e7a6a70fe14f0a2f92b96cbcb4/macos/osg.patch";
        sha256 = "sha256-G8Y+fnR6FRGxECWrei/Ixch3A3PkRfH6b5q9iawsSCY=";
      })
    ];
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-Wno-dev"
      "-DOpenGL_GL_PREFERENCE=${GL}"
      "-DBUILD_OSG_PLUGINS_BY_DEFAULT=0"
      "-DBUILD_OSG_DEPRECATED_SERIALIZERS=0"
    ] ++ (map (e: "-DBUILD_OSG_PLUGIN_${e}=1") [ "BMP" "DAE" "DDS" "FREETYPE" "JPEG" "OSG" "PNG" "TGA" ]);
  });

  bullet' = bullet.overrideDerivation (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-Wno-dev"
      "-DOpenGL_GL_PREFERENCE=${GL}"
      "-DUSE_DOUBLE_PRECISION=ON"
      "-DBULLET2_MULTITHREADING=ON"
    ];
  });

in
stdenv.mkDerivation rec {
  pname = "openmw";
  version = "0.48.0";

  src = fetchFromGitLab {
    owner = "OpenMW";
    repo = "openmw";
    rev = "${pname}-${version}";
    hash = "sha256-zkjVt3GfQZsFXl2Ht3lCuQtDMYQWxhdFO4aGSb3rsyo=";
  };

  postPatch = ''
    sed '1i#include <memory>' -i components/myguiplatform/myguidatamanager.cpp # gcc12
  '' + lib.optionalString stdenv.isDarwin ''
    # Don't fix Darwin app bundle
    sed -i '/fixup_bundle/d' CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  # If not set, OSG plugin .so files become shell scripts on Darwin.
  dontWrapQtApps = stdenv.isDarwin;

  buildInputs = [
    SDL2
    boost
    bullet'
    ffmpeg
    libXt
    luajit
    lz4
    mygui
    openal
    osg'
    recastnavigation
    unshield
    yaml-cpp
  ] ++ lib.optionals stdenv.isDarwin [
    CoreMedia
    VideoDecodeAcceleration
    VideoToolbox
  ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=${GL}"
    "-DOPENMW_USE_SYSTEM_RECASTNAVIGATION=1"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DOPENMW_OSX_DEPLOYMENT=ON"
  ];

  meta = with lib; {
    description = "Unofficial open source engine reimplementation of the game Morrowind";
    homepage = "https://openmw.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ abbradar marius851000 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
