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

  withGL ? "GLVND",
}:

assert lib.assertOneOf "withGL" withGL [
  "GLVND"
  "LEGACY"
];

let
  osg' = (openscenegraph.override { colladaSupport = true; }).overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (fetchpatch {
        # Darwin: Without this patch, OSG won't build osgdb_png.so, which is required by OpenMW.
        name = "darwin-osg-plugins-fix.patch";
        url = "https://gitlab.com/OpenMW/openmw-dep/-/raw/1305497c009dc0e7a6a70fe14f0a2f92b96cbcb4/macos/osg.patch";
        sha256 = "sha256-G8Y+fnR6FRGxECWrei/Ixch3A3PkRfH6b5q9iawsSCY=";
      })
    ];
    cmakeFlags =
      (oldAttrs.cmakeFlags or [ ])
      ++ [
        "-Wno-dev"
        (lib.cmakeFeature "OpenGL_GL_PREFERENCE" withGL)
        (lib.cmakeBool "BUILD_OSG_PLUGINS_BY_DEFAULT" false)
        (lib.cmakeBool "BUILD_OSG_DEPRECATED_SERIALIZERS" false)
      ]
      ++ (map (plugin: lib.cmakeBool "BUILD_OSG_PLUGIN_${plugin}" true) [
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

  bullet' = bullet.overrideAttrs (oldAttrs: {
    cmakeFlags = (oldAttrs.cmakeFlags or [ ]) ++ [
      "-Wno-dev"
      (lib.cmakeFeature "OpenGL_GL_PREFERENCE" withGL)
      (lib.cmakeBool "USE_DOUBLE_PRECISION" true)
      (lib.cmakeBool "BULLET2_MULTITHREADING" true)
    ];
  });

in
stdenv.mkDerivation (finalAttrs: {
  pname = "openmw";
  version = "0.49.0";

  src = fetchFromGitLab {
    owner = "OpenMW";
    repo = "openmw";
    tag = "openmw-${finalAttrs.version}";
    hash = "sha256-Eyjn3jPpo0d7XENg0Ea/3MN60lZBSUAMkz1UtTiIP80=";
  };

  postPatch =
    ''
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
    (lib.cmakeFeature "OpenGL_GL_PREFERENCE" withGL)
    (lib.cmakeBool "OPENMW_USE_SYSTEM_RECASTNAVIGATION" true)
  ] ++ lib.optional stdenv.hostPlatform.isDarwin (lib.cmakeBool "OPENMW_OSX_DEPLOYMENT" true);

  meta = {
    description = "Unofficial open source engine reimplementation of the game Morrowind";
    changelog = "https://gitlab.com/OpenMW/openmw/-/blob/openmw-${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://openmw.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      abbradar
      marius851000
      sigmasquadron
    ];
    platforms = with lib.platforms; (linux ++ darwin);
  };
})
