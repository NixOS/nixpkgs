{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,

  SDL2,
  boost,
  bullet,
  cmake,
  ffmpeg,
  libXt,
  luajit,
  lz4,
  mygui,
  openal,
  openscenegraph,
  pkg-config,
  qttools,
  recastnavigation,
  unshield,
  wrapQtAppsHook,
  yaml-cpp,
}:

let
  GL = "GLVND"; # or "LEGACY";

  osg' = (openscenegraph.override { colladaSupport = true; }).overrideDerivation (old: {
    patches = [
      (fetchpatch {
        # Darwin: Without this patch, OSG won't build osgdb_png.so, which is required by OpenMW.
        name = "darwin-osg-plugins-fix.patch";
        url = "https://gitlab.com/OpenMW/openmw-dep/-/raw/1305497c009dc0e7a6a70fe14f0a2f92b96cbcb4/macos/osg.patch";
        sha256 = "sha256-G8Y+fnR6FRGxECWrei/Ixch3A3PkRfH6b5q9iawsSCY=";
      })
    ];
    cmakeFlags =
      (old.cmakeFlags or [ ])
      ++ [
        "-Wno-dev"
        "-DOpenGL_GL_PREFERENCE=${GL}"
        "-DBUILD_OSG_PLUGINS_BY_DEFAULT=0"
        "-DBUILD_OSG_DEPRECATED_SERIALIZERS=0"
      ]
      ++ (map (e: "-DBUILD_OSG_PLUGIN_${e}=1") [
        "BMP"
        "DAE"
        "DDS"
        "FREETYPE"
        "JPEG"
        "OSG"
        "PNG"
        "TGA"
      ]);
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
  version = "0.49.0";

  src = fetchFromGitLab {
    owner = "OpenMW";
    repo = "openmw";
    rev = "${pname}-${version}";
    hash = "sha256-Eyjn3jPpo0d7XENg0Ea/3MN60lZBSUAMkz1UtTiIP80=";
  };

  postPatch = ''
    sed '1i#include <memory>' -i components/myguiplatform/myguidatamanager.cpp # gcc12
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Don't fix Darwin app bundle
    sed -i '/fixup_bundle/d' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  # If not set, OSG plugin .so files become shell scripts on Darwin.
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

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
    qttools
    recastnavigation
    unshield
    yaml-cpp
  ];

  cmakeFlags = [
    "-DOpenGL_GL_PREFERENCE=${GL}"
    "-DOPENMW_USE_SYSTEM_RECASTNAVIGATION=1"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DOPENMW_OSX_DEPLOYMENT=ON"
  ];

  meta = with lib; {
    description = "Unofficial open source engine reimplementation of the game Morrowind";
    homepage = "https://openmw.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      marius851000
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
