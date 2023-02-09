{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, gitUpdater
, cmake
, pkg-config
, python3
, doxygen
, libxslt
, boost
, egl-wayland
, freetype
, glib
, glm
, glog
, libdrm
, libepoxy
, libevdev
, libglvnd
, libinput
, libuuid
, libxcb
, libxkbcommon
, libxmlxx
, yaml-cpp
, lttng-ust
, mesa
, nettle
, udev
, wayland
, xorg
, xwayland
, dbus
, gtest
, umockdev
, wlcs
}:

let
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  pythonEnv = python3.withPackages(ps: with ps; [
    pillow
  ] ++ lib.optionals doCheck [
    pygobject3
    python-dbusmock
  ]);
in

stdenv.mkDerivation rec {
  pname = "mir";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "MirServer";
    repo = "mir";
    rev = "v${version}";
    hash = "sha256-HQmcYnmzeJCsgMoM/y70PCF+3umZh0xJS5S0wFODlmo=";
  };

  patches = [
    # Fixes various path concatenation problems and missing GNUInstallDirs variable uses that affect
    # install locations and generated pkg-config files
    # Remove when a version > 2.12.0 has the fixes
    (fetchpatch {
      name = "0001-mir-Better-install-path-concatenations-and-more-GNUInstallDirs-variables.patch";
      url = "https://github.com/MirServer/mir/commit/58c4ca628748278b1eb7a3721ad9a0c3590e28f2.patch";
      hash = "sha256-+FNVlApaVzA94cy4awulLwTtggD07xACbvjII/RxyRM=";
    })
    # Fixes doc building
    # Remove when a version > 2.12.0 has the fix
    (fetchpatch {
      name = "0002-mir-better-removal-of-existing-docs.patch";
      url = "https://github.com/MirServer/mir/commit/04892531c988201f0219ce140f27d7ff60eeebd5.patch";
      hash = "sha256-LyGgaIoe6mk4IQxBo6Xk5SmIBtTXOXAOA1xAgsdhcLY=";
    })
  ];

  postPatch = ''
    # Fix scripts that get run in tests
    patchShebangs tools/detect_fd_leaks.bash tests/acceptance-tests/wayland-generator/test_wayland_generator.sh.in

    # Fix LD_PRELOADing in tests
    for needsPreloadFixing in \
      cmake/MirCommon.cmake \
      tests/umock-acceptance-tests/CMakeLists.txt \
      tests/unit-tests/platforms/gbm-kms/kms/CMakeLists.txt \
      tests/unit-tests/CMakeLists.txt
    do
      substituteInPlace $needsPreloadFixing \
        --replace 'LD_PRELOAD=liblttng-ust-fork.so' 'LD_PRELOAD=${lib.getLib lttng-ust}/lib/liblttng-ust-fork.so' \
        --replace 'LD_PRELOAD=libumockdev-preload.so.0' 'LD_PRELOAD=${lib.getLib umockdev}/lib/libumockdev-preload.so.0'
    done

    # Fix Xwayland default
    substituteInPlace src/miral/x11_support.cpp \
      --replace '/usr/bin/Xwayland' '${xwayland}/bin/Xwayland'

    # Fix paths for generating drm-formats
    substituteInPlace src/platform/graphics/CMakeLists.txt \
      --replace "/usr/include/drm/drm_fourcc.h" "${lib.getDev libdrm}/include/libdrm/drm_fourcc.h" \
      --replace "/usr/include/libdrm/drm_fourcc.h" "${lib.getDev libdrm}/include/libdrm/drm_fourcc.h"

    # Fix date in generated docs not honouring SOURCE_DATE_EPOCH
    # Install docs to correct dir
    substituteInPlace cmake/Doxygen.cmake \
      --replace '"date"' '"date" "--date=@'"$SOURCE_DATE_EPOCH"'"' \
      --replace "\''${CMAKE_INSTALL_PREFIX}/share/doc/mir-doc" "\''${CMAKE_INSTALL_DOCDIR}"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    glib # gdbus-codegen
    libxslt
    lttng-ust # lttng-gen-tp
    pkg-config
    pythonEnv
  ];

  buildInputs = [
    boost
    egl-wayland
    freetype
    glib
    glm
    glog
    libdrm
    libepoxy
    libevdev
    libglvnd
    libinput
    libuuid
    libxcb
    libxkbcommon
    libxmlxx
    yaml-cpp
    lttng-ust
    mesa
    nettle
    udev
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.xorgproto
    xwayland
  ] ++ lib.optionals doCheck [
    gtest
    umockdev
    wlcs
  ];

  nativeCheckInputs = [
    dbus
  ];

  buildFlags = [ "all" "doc" ];

  cmakeFlags = [
    "-DMIR_PLATFORM='gbm-kms;x11;eglstream-kms;wayland'"
    "-DMIR_ENABLE_TESTS=${if doCheck then "ON" else "OFF"}"
    # BadBufferTest.test_truncated_shm_file *doesn't* throw an error as the test expected, mark as such
    # https://github.com/MirServer/mir/pull/1947#issuecomment-811810872
    "-DMIR_SIGBUS_HANDLER_ENVIRONMENT_BROKEN=ON"
    "-DMIR_EXCLUDE_TESTS=${lib.strings.concatStringsSep ";" [
    ]}"
    # These get built but don't get executed by default, yet they get installed when tests are enabled
    "-DMIR_BUILD_PERFORMANCE_TESTS=OFF"
    "-DMIR_BUILD_PLATFORM_TEST_HARNESS=OFF"
  ];

  inherit doCheck;

  preCheck = ''
    # Needs to be exactly /tmp so some failing tests don't get run, don't know why they fail yet
    # https://github.com/MirServer/mir/issues/2801
    export XDG_RUNTIME_DIR=/tmp
  '';

  checkTarget = "ptest";

  outputs = [ "out" "dev" "doc" ];

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
    # More of an example than a fully functioning shell, some notes for the adventurous:
    # - ~/.config/miral-shell.config is one possible user config location,
    #   accepted options=value are according to `mir-shell --help`
    # - default icon theme setting is DMZ-White, needs vanilla-dmz installed & on XCURSOR_PATH
    #   or setting to be changed to an available theme
    # - terminal emulator setting may need to be changed if miral-terminal script
    #   does not know about preferred terminal
    providedSessions = [ "mir-shell" ];
  };

  meta = with lib; {
    description = "A display server and Wayland compositor developed by Canonical";
    homepage = "https://mir-server.io";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny OPNA2608 ];
    platforms = platforms.linux;
  };
}
