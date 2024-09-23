{
  stdenv,
  lib,
  fetchFromGitHub,
  testers,
  cmake,
  pkg-config,
  python3,
  boost,
  egl-wayland,
  freetype,
  glib,
  glm,
  glog,
  libdrm,
  libepoxy,
  libevdev,
  libglvnd,
  libinput,
  libuuid,
  libxcb,
  libxkbcommon,
  libxmlxx,
  yaml-cpp,
  lttng-ust,
  mesa,
  nettle,
  udev,
  wayland,
  wayland-scanner,
  xorg,
  xwayland,
  dbus,
  gobject-introspection,
  gtest,
  umockdev,
  wlcs,
  validatePkgConfig,
}:

{
  version,
  pinned ? false,
  hash,
  patches ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mir";
  inherit version;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "mir";
    rev = "v${finalAttrs.version}";
    inherit hash;
  };

  inherit patches;

  postPatch = ''
    # Fix scripts that get run in tests
    patchShebangs tools/detect_fd_leaks.bash tests/acceptance-tests/wayland-generator/test_wayland_generator.sh.in

    # Fix LD_PRELOADing in tests
    substituteInPlace \
      cmake/MirCommon.cmake \
      tests/umock-acceptance-tests/CMakeLists.txt \
      tests/unit-tests/platforms/gbm-kms/kms/CMakeLists.txt \
      tests/unit-tests/CMakeLists.txt \
      --replace-warn 'LD_PRELOAD=liblttng-ust-fork.so' 'LD_PRELOAD=${lib.getLib lttng-ust}/lib/liblttng-ust-fork.so' \
      --replace-warn 'LD_PRELOAD=libumockdev-preload.so.0' 'LD_PRELOAD=${lib.getLib umockdev}/lib/libumockdev-preload.so.0'

    # Fix Xwayland default
    substituteInPlace src/miral/x11_support.cpp \
      --replace-fail '/usr/bin/Xwayland' '${lib.getExe xwayland}'

    # Fix paths for generating drm-formats
    substituteInPlace src/platform/graphics/CMakeLists.txt \
      --replace-fail "/usr/include/drm/drm_fourcc.h" "${lib.getDev libdrm}/include/libdrm/drm_fourcc.h" \
      --replace-fail "/usr/include/libdrm/drm_fourcc.h" "${lib.getDev libdrm}/include/libdrm/drm_fourcc.h"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # gdbus-codegen
    lttng-ust # lttng-gen-tp
    pkg-config
    (python3.withPackages (
      ps:
      with ps;
      [ pillow ]
      ++ lib.optionals finalAttrs.finalPackage.doCheck [
        pygobject3
        python-dbusmock
      ]
    ))
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
    (lib.cmakeFeature "MIR_PLATFORM" (
      lib.strings.concatStringsSep ";" [
        "gbm-kms"
        "x11"
        "eglstream-kms"
        "wayland"
      ]
    ))
    (lib.cmakeBool "MIR_ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    # BadBufferTest.test_truncated_shm_file *doesn't* throw an error as the test expected, mark as such
    # https://github.com/canonical/mir/pull/1947#issuecomment-811810872
    (lib.cmakeBool "MIR_SIGBUS_HANDLER_ENVIRONMENT_BROKEN" true)
    (lib.cmakeFeature "MIR_EXCLUDE_TESTS" (lib.strings.concatStringsSep ";" [ ]))
    # These get built but don't get executed by default, yet they get installed when tests are enabled
    (lib.cmakeBool "MIR_BUILD_PERFORMANCE_TESTS" false)
    (lib.cmakeBool "MIR_BUILD_PLATFORM_TEST_HARNESS" false)
    # https://github.com/canonical/mir/issues/2987
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106799
    (lib.cmakeBool "MIR_USE_PRECOMPILED_HEADERS" false)
    (lib.cmakeFeature "MIR_COMPILER_QUIRKS" (
      lib.strings.concatStringsSep ";" [
        # https://github.com/canonical/mir/issues/3017 actually affects x86_64 as well
        "test_touchspot_controller.cpp:array-bounds"
      ]
    ))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export XDG_RUNTIME_DIR=$TMP
  '';

  outputs = [
    "out"
    "dev"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    providedSessions = lib.optionals (lib.strings.versionOlder version "2.16.0") [
      # More of an example than a fully functioning shell, some notes for the adventurous:
      # - ~/.config/miral-shell.config is one possible user config location,
      #   accepted options=value are according to `mir-shell --help`
      # - default icon theme setting is DMZ-White, needs vanilla-dmz installed & on XCURSOR_PATH
      #   or setting to be changed to an available theme
      # - terminal emulator setting may need to be changed if miral-terminal script
      #   does not know about preferred terminal
      "mir-shell"
    ];
  } // lib.optionalAttrs (!pinned) {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Display server and Wayland compositor developed by Canonical";
    homepage = "https://mir-server.io";
    changelog = "https://github.com/canonical/mir/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      onny
      OPNA2608
    ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "miral"
      "mircommon"
      "mircore"
      "miroil"
      "mirplatform"
      "mir-renderer-gl-dev"
      "mirrenderer"
      "mirserver"
      "mirtest"
      "mirwayland"
    ] ++ lib.optionals (lib.strings.versionOlder version "2.17.0") [
      "mircookie"
    ] ++ lib.optionals (lib.strings.versionAtLeast version "2.17.0") [
      "mircommon-internal"
      "mirserver-internal"
    ];
  };
})
