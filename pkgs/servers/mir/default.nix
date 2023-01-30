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
, libyamlcpp
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
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "MirServer";
    repo = "mir";
    rev = "v${version}";
    hash = "sha256-103PJZEoSgtSbDGCanD2/XdpX6DXXx678GmghdZI7H4=";
  };

  patches = [
    # These four patches fix various path concatenation problems and missing GNUInstallDirs variable uses that affect
    # install locations and generated pkg-config files
    # Remove when MirServer/mir/pull/2786 merged & a version > 2.11.0 has the fixes
    (fetchpatch {
      name = "0001-mir-Better-pkg-config-path-concatenations.patch";
      url = "https://github.com/MirServer/mir/pull/2786/commits/a322be08002ae7b2682d3ca7037c314ce900d3c7.patch";
      hash = "sha256-6nScVan3eefXZb+0T9TvCjRQt+rCMj27sukpdGMVJzY=";
    })
    (fetchpatch {
      name = "0002-mir-Improve-mirtest-pkg-config.patch";
      url = "https://github.com/MirServer/mir/pull/2786/commits/7a739fde27f5f5eff0ec33f766a807c3ff462663.patch";
      hash = "sha256-C2cDN4R0C4654Km27PJwKrNiFi/d0iz9/rcABS6eRVI=";
    })
    (fetchpatch {
      name = "0003-mir-Fix-GNUInstallDirs-variable-concatenations-in-CMake.patch";
      url = "https://github.com/MirServer/mir/pull/2786/commits/543e1ec0162f95611b282d33a2e81a642dc75374.patch";
      hash = "sha256-nxgj8tTfSqjRxqi67hAuWM9d604TAwhNjUXwGDAEW6A=";
    })
    (fetchpatch {
      name = "0004-mir-More-GNUInstallDirs-variables-less-FULL.patch";
      url = "https://github.com/MirServer/mir/pull/2786/commits/0cb0a1d5e3ac4aca25ca2ebacdcb984d7ff3a66a.patch";
      hash = "sha256-rnDvr8ul/GgajHYbpale+szNE6VDgENRY6PnBhfGMN8=";
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

    # Patch in which tests we want to skip
    substituteInPlace cmake/MirCommon.cmake \
      --replace 'set(test_exclusion_filter)' 'set(test_exclusion_filter "${lib.strings.concatStringsSep ":" [
        # These all fail in the same way: GDK_BACKEND expected to have "wayland", actually has "wayland,x11".
        # They succeed when run interactively, don't know how to fix them.
        "ExternalClient.empty_override_does_nothing"
        "ExternalClient.strange_override_does_nothing"
        "ExternalClient.another_strange_override_does_nothing"
      ]}")'

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

    # Not installed on Mir HEAD anymore, hence not part of the MirServer/mir/pull/2786 patches
    substituteInPlace examples/miral-kiosk/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_PREFIX}/bin" "\''${CMAKE_INSTALL_BINDIR}"
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
    libyamlcpp
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
    # Eventually renamed to MIR_SIGBUS_HANDLER_ENVIRONMENT_BROKEN
    "-DMIR_BAD_BUFFER_TEST_ENVIRONMENT_BROKEN=ON"
    # These get built but don't get executed by default, yet they get installed when tests are enabled
    "-DMIR_BUILD_PERFORMANCE_TESTS=OFF"
    "-DMIR_BUILD_PLATFORM_TEST_HARNESS=OFF"
  ];

  inherit doCheck;

  preCheck = ''
    export XDG_RUNTIME_DIR=$TMPDIR
  '';

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
