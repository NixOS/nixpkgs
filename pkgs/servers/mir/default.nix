{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, gitUpdater
, testers
, cmake
, pkg-config
, python3
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
, gobject-introspection
, gtest
, umockdev
, wlcs
, validatePkgConfig
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mir";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "MirServer";
    repo = "mir";
    rev = "v${finalAttrs.version}";
    hash = "sha256-c1+gxzLEtNCjR/mx76O5QElQ8+AO4WsfcG7Wy1+nC6E=";
  };

  patches = [
    # Fix gbm-kms tests
    # Remove when version > 2.15.0
    (fetchpatch {
      name = "0001-mir-Fix-the-signature-of-drmModeCrtcSetGamma.patch";
      url = "https://github.com/MirServer/mir/commit/98250e9c32c5b9b940da2fb0a32d8139bbc68157.patch";
      hash = "sha256-tTtOHGNue5rsppOIQSfkOH5sVfFSn/KPGHmubNlRtLI=";
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
      --replace '/usr/bin/Xwayland' '${lib.getExe xwayland}'

    # Fix paths for generating drm-formats
    substituteInPlace src/platform/graphics/CMakeLists.txt \
      --replace "/usr/include/drm/drm_fourcc.h" "${lib.getDev libdrm}/include/libdrm/drm_fourcc.h" \
      --replace "/usr/include/libdrm/drm_fourcc.h" "${lib.getDev libdrm}/include/libdrm/drm_fourcc.h"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # gdbus-codegen
    lttng-ust # lttng-gen-tp
    pkg-config
    (python3.withPackages (ps: with ps; [
      pillow
    ] ++ lib.optionals finalAttrs.finalPackage.doCheck [
      pygobject3
      python-dbusmock
    ]))
    validatePkgConfig
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
  ];

  nativeCheckInputs = [
    dbus
    gobject-introspection
  ];

  checkInputs = [
    gtest
    umockdev
    wlcs
  ];

  cmakeFlags = [
    "-DBUILD_DOXYGEN=OFF"
    "-DMIR_PLATFORM='gbm-kms;x11;eglstream-kms;wayland'"
    "-DMIR_ENABLE_TESTS=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    # BadBufferTest.test_truncated_shm_file *doesn't* throw an error as the test expected, mark as such
    # https://github.com/MirServer/mir/pull/1947#issuecomment-811810872
    "-DMIR_SIGBUS_HANDLER_ENVIRONMENT_BROKEN=ON"
    "-DMIR_EXCLUDE_TESTS=${lib.strings.concatStringsSep ";" [
    ]}"
    # These get built but don't get executed by default, yet they get installed when tests are enabled
    "-DMIR_BUILD_PERFORMANCE_TESTS=OFF"
    "-DMIR_BUILD_PLATFORM_TEST_HARNESS=OFF"
    # https://github.com/MirServer/mir/issues/2987
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106799
    "-DMIR_USE_PRECOMPILED_HEADERS=OFF"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    # Needs to be exactly /tmp so some failing tests don't get run, don't know why they fail yet
    # https://github.com/MirServer/mir/issues/2801
    export XDG_RUNTIME_DIR=/tmp
  '';

  outputs = [ "out" "dev" ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
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
    changelog = "https://github.com/MirServer/mir/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny OPNA2608 ];
    platforms = platforms.linux;
    pkgConfigModules = [
      "miral"
      "mircommon"
      "mircookie"
      "mircore"
      "miroil"
      "mirplatform"
      "mir-renderer-gl-dev"
      "mirrenderer"
      "mirserver"
      "mirtest"
      "mirwayland"
    ];
  };
})
