{ stdenv
, lib
, fetchFromGitHub
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
, wayland-scanner
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
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "mir";
    rev = "v${finalAttrs.version}";
    hash = "sha256-iDJ7NIFoSSXjMrHK2I6Linf7z0hvShj8fr6BGxgK5gE=";
  };

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
    wayland-scanner
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
    (lib.cmakeBool "BUILD_DOXYGEN" false)
    (lib.cmakeFeature "MIR_PLATFORM" (lib.strings.concatStringsSep ";" [
      "gbm-kms"
      "x11"
      "eglstream-kms"
      "wayland"
    ]))
    (lib.cmakeBool "MIR_ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    # BadBufferTest.test_truncated_shm_file *doesn't* throw an error as the test expected, mark as such
    # https://github.com/canonical/mir/pull/1947#issuecomment-811810872
    (lib.cmakeBool "MIR_SIGBUS_HANDLER_ENVIRONMENT_BROKEN" true)
    (lib.cmakeFeature "MIR_EXCLUDE_TESTS" (lib.strings.concatStringsSep ";" [
    ]))
    # These get built but don't get executed by default, yet they get installed when tests are enabled
    (lib.cmakeBool "MIR_BUILD_PERFORMANCE_TESTS" false)
    (lib.cmakeBool "MIR_BUILD_PLATFORM_TEST_HARNESS" false)
    # https://github.com/canonical/mir/issues/2987
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106799
    (lib.cmakeBool "MIR_USE_PRECOMPILED_HEADERS" false)
    (lib.cmakeFeature "MIR_COMPILER_QUIRKS" (lib.strings.concatStringsSep ";" [
      # https://github.com/canonical/mir/issues/3017 actually affects x86_64 as well
      "test_touchspot_controller.cpp:array-bounds"
    ]))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export XDG_RUNTIME_DIR=$TMP
  '';

  outputs = [ "out" "dev" ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "A display server and Wayland compositor developed by Canonical";
    homepage = "https://mir-server.io";
    changelog = "https://github.com/canonical/mir/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ onny OPNA2608 ];
    platforms = platforms.linux;
    pkgConfigModules = [
      "miral"
      "mircommon"
      "mircommon-internal"
      "mircore"
      "miroil"
      "mirplatform"
      "mir-renderer-gl-dev"
      "mirrenderer"
      "mirserver"
      "mirserver-internal"
      "mirtest"
      "mirwayland"
    ];
  };
})
