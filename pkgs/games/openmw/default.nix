{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  SDL2,
  CoreMedia,
  VideoToolbox,
  VideoDecodeAcceleration,
  boost,
  bullet,
  # Please unpin this on the next OpenMW release.
  ffmpeg_6,
  libXt,
  luajit,
  lz4,
  mygui,
  openal,
  openscenegraph,
  recastnavigation,
  unshield,
  yaml-cpp,
}:

let
  GL = "GLVND"; # or "LEGACY";

  osg' = (openscenegraph.override { colladaSupport = true; }).overrideDerivation (old: {
    patches = [
      (fetchpatch {
        # Darwin: Without this patch, OSG won't build osgdb_png.so, which is required by OpenMW.
        name = "darwin-osg-plugins-fix.patch";
        url = "https://gitlab.com/OpenMW/openmw-dep/-/raw/0abe3c9c3858211028d881d7706813d606335f72/macos/osg.patch";
        sha256 = "sha256-/CLRZofZHot8juH78VG1/qhTHPhy5DoPMN+oH8hC58U=";
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
  version = "0.48.0";

  src = fetchFromGitLab {
    owner = "OpenMW";
    repo = "openmw";
    rev = "${pname}-${version}";
    hash = "sha256-zkjVt3GfQZsFXl2Ht3lCuQtDMYQWxhdFO4aGSb3rsyo=";
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

  buildInputs =
    [
      SDL2
      boost
      bullet'
      ffmpeg_6
      libXt
      luajit
      lz4
      mygui
      openal
      osg'
      recastnavigation
      unshield
      yaml-cpp
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreMedia
      VideoDecodeAcceleration
      VideoToolbox
    ];

  cmakeFlags =
    [
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
      abbradar
      marius851000
    ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
