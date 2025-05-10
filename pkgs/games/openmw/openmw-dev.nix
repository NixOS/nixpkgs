{ lib
, stdenv
, fetchFromGitLab
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

    mygui' = pkgs.mygui.overrideAttrs (finalAttrs: previousAttrs: {
        pname = "mygui";
        version = "3.4.3";

        src = pkgs.fetchFromGitHub {
            owner = "MyGUI";
            repo = "mygui";
            rev = "MyGUI${finalAttrs.version}";
            hash = "sha256-qif9trHgtWpYiDVXY3cjRsXypjjjgStX8tSWCnXhXlk=";
        };

        patches = [];

        cmakeFlags = previousAttrs.cmakeFlags ++ [
            "-DMYGUI_RENDERSYSTEM=1"
            "-DMYGUI_BUILD_DEMOS=OFF"
            "-DMYGUI_BUILD_TOOLS=OFF"
            "-DMYGUI_BUILD_PLUGINS=OFF"
            "-DMYGUI_DONT_USE_OBSOLETE=ON"
        ];
    });

    osg' = (openscenegraph.override { colladaSupport = true; }).overrideDerivation (old: {
      patches = [
        (fetchpatch {
          # Darwin: Without this patch, OSG won't build osgdb_png.so, which is required by OpenMW.
          name = "darwin-osg-plugins-fix.patch";
          url = "https://gitlab.com/OpenMW/openmw-dep/-/raw/0abe3c9c3858211028d881d7706813d606335f72/macos/osg.patch";
          sha256 = "sha256-/CLRZofZHot8juH78VG1/qhTHPhy5DoPMN+oH8hC58U=";
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
  pname = "openmw-dev";
  version = "4.8.0";

  src = fetchFromGitLab {
    owner = "OpenMW";
    repo = "openmw";
    rev = "488a05d14cdd7ed21c0c7d6433fcb607df7538ae";
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
    mygui'
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
