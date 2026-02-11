{
  stdenv,
  rustPlatform,
  lib,
  common-updater-scripts,
  fetchFromGitHub,
  genericUpdater,
  gitUpdater,
  nixosTests,
  testers,
  cargo,
  cmake,
  ctestCheckHook,
  pkg-config,
  python3,
  boost,
  egl-wayland,
  freetype,
  glib,
  glm,
  libapparmor,
  libdisplay-info,
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
  libgbm,
  mesa,
  nettle,
  pixman,
  udev,
  wayland,
  wayland-scanner,
  libxcursor,
  libx11,
  xorgproto,
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
  cargoHash ? null,
  patches ? [ ],
}:

stdenv.mkDerivation (
  finalAttrs:
  {
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
    ''
    + lib.optionalString (lib.strings.versionOlder version "2.18.0") ''

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
    ]
    ++ lib.optionals (lib.strings.versionAtLeast version "2.22.0") [
      rustPlatform.cargoSetupHook
      cargo
    ];

    buildInputs = [
      boost
      egl-wayland
      freetype
      glib
      glm
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
      libgbm
      nettle
      udev
      wayland
      libx11
      libxcursor
      xorgproto
      xwayland
    ]
    ++ lib.optionals (lib.strings.versionAtLeast version "2.18.0") [
      libapparmor
    ]
    ++ lib.optionals (lib.strings.versionAtLeast version "2.21.0") [
      pixman
    ]
    ++ lib.optionals (lib.strings.versionAtLeast version "2.22.0") [
      libdisplay-info
    ];

    nativeCheckInputs = [
      ctestCheckHook
      dbus
      gobject-introspection
    ]
    ++ lib.optionals (lib.strings.versionAtLeast version "2.22.0") [
      mesa.llvmpipeHook
    ]
    ++ lib.optionals (lib.strings.versionAtLeast version "2.23.0") [
      xwayland
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
          "atomic-kms"
          "gbm-kms"
          "eglstream-kms"
          "x11"
          "wayland"
        ]
      ))
      (lib.cmakeBool "MIR_ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
      # BadBufferTest.test_truncated_shm_file *doesn't* throw an error as the test expected, mark as such
      # https://github.com/canonical/mir/pull/1947#issuecomment-811810872
      (lib.cmakeBool "MIR_SIGBUS_HANDLER_ENVIRONMENT_BROKEN" true)
      (lib.cmakeFeature "MIR_EXCLUDE_TESTS" (
        lib.strings.concatStringsSep ";" (
          lib.optionals (lib.strings.versionOlder version "2.22.0") [
            # https://github.com/canonical/mir/issues/3716#issuecomment-2580698552
            "UdevWrapperTest.UdevMonitorDoesNotTriggerBeforeEnabling"
          ]
        )
      ))
      # These get built but don't get executed by default, yet they get installed when tests are enabled
      (lib.cmakeBool "MIR_BUILD_PERFORMANCE_TESTS" false)
      (lib.cmakeBool "MIR_BUILD_PLATFORM_TEST_HARNESS" false)
      (lib.cmakeBool "MIR_USE_APPARMOR" true)
      (lib.cmakeBool "MIR_ENABLE_RUST" true)
      # https://github.com/canonical/mir/issues/2987
      # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=106799
      (lib.cmakeBool "MIR_USE_PRECOMPILED_HEADERS" false)
      (lib.cmakeFeature "MIR_COMPILER_QUIRKS" (
        lib.strings.concatStringsSep ";" (
          lib.optionals (lib.strings.versionOlder version "2.22.0") [
            # https://github.com/canonical/mir/issues/3017 actually affects x86_64 as well
            "test_touchspot_controller.cpp:array-bounds"
          ]
        )
      ))
    ];

    env.NIX_CFLAGS_COMPILE = lib.optionalString (lib.strings.versionOlder version "2.20.0") (toString [
      # std::wstring_convert<std::codecvt_utf8[...]> in src/server/shell/decoration/renderer.cpp is deprecated in C++17, removed in C++26
      # Upstream just disabled the warning for now: https://github.com/canonical/mir/commit/e8d1a2255a48991f20889e5844b0d69f5f75d01f
      # File got ripped apart and shuffled around between 2.15 and 2.20, so can't just add as patch
      "-Wno-error=deprecated-declarations"
    ]);

    doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

    disabledTests = lib.optionals (lib.strings.versionAtLeast version "2.25.0") [
      # We don't care about the documentation, so we also don't care if there are any changes in it
      "verify-options-reference-unchanged"
    ];

    preCheck = ''
      export HOME=$TMP # shader cache
      export XDG_RUNTIME_DIR=$TMP
    '';

    outputs = [
      "out"
      "dev"
    ];

    passthru = {
      tests = {
        pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
      }
      // lib.optionalAttrs (!pinned) { inherit (nixosTests) miriway miracle-wm; };
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
    }
    // lib.optionalAttrs (!pinned) {
      updateScript =
        let
          cusWithFlag = common-updater-scripts.overrideAttrs (oa: {
            # Have to double-wrap it...
            installPhase = oa.installPhase + ''
              wrapProgram $out/bin/update-source-version \
                --add-flag '--file=${lib.strings.removeSuffix "/common.nix" __curPos.file}/default.nix'
            '';
          });
        in
        # Attrs to update are in default.nix
        (gitUpdater.override {
          common-updater-scripts = cusWithFlag;
          genericUpdater = genericUpdater.override {
            common-updater-scripts = cusWithFlag;
          };
        })
          {
            rev-prefix = "v";
            ignoredVersions = "-(dev|rc)$";
          };
    };

    meta = {
      description = "Display server and Wayland compositor developed by Canonical";
      homepage = "https://mir-server.io";
      changelog = "https://github.com/canonical/mir/releases/tag/v${finalAttrs.version}";
      license = lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [
        OPNA2608
      ];
      # Onle LE has valid graphics buffer formats
      # https://github.com/canonical/mir/blob/ba8e83f75084379dec8e23131fdf04fa4a4567ac/src/platforms/common/server/shm_buffer.cpp#L61-L65
      platforms = lib.lists.intersectLists lib.platforms.linux lib.platforms.littleEndian;
      pkgConfigModules = [
        "miral"
        "mircommon"
        "mircore"
        "miroil"
        "mirplatform"
        "mirserver"
        "mirtest"
        "mirwayland"
      ]
      ++ lib.optionals (lib.strings.versionOlder version "2.17.0") [ "mircookie" ]
      ++ lib.optionals (lib.strings.versionAtLeast version "2.17.0") [
        "mircommon-internal"
        "mirserver-internal"
      ]
      ++ lib.optionals (lib.strings.versionOlder version "2.25.0") [
        "mir-renderer-gl-dev"
        "mirrenderer"
      ];
    };
  }
  // lib.optionalAttrs (lib.strings.versionAtLeast version "2.22.0") {
    cargoDeps = rustPlatform.fetchCargoVendor {
      src = finalAttrs.src;
      sourceRoot = finalAttrs.src.name;
      hash = cargoHash;
    };
  }
)
