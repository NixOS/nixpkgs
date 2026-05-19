{
  stdenv,
  lib,
  fetchzip,
  docbook_xsl,
  gtk-doc,
  pkg-config,
  xz,
  zstd,
  withDevdoc ? stdenv.hostPlatform == stdenv.buildPlatform,
  withStatic ? stdenv.hostPlatform.isStatic,
  gitUpdater,
  scdoc,
  meson,
  ninja,
  zlib,
}:

let
  systems = [
    "/run/booted-system/kernel-modules"
    "/run/current-system/kernel-modules"
    ""
  ];
  modulesDirs = lib.concatMapStringsSep "," (x: "${x}/lib/modules") systems;

in
stdenv.mkDerivation rec {
  pname = "kmod";
  version = "34.2";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/snapshot/kmod-${version}.tar.gz";
    hash = "sha256-+fSM9ver+Yg9YbKuqiheKbqkLaZBPRuu0dey6gXQHyE=";
  };

  outputs = [
    "out"
    "man"
    "dev"
    "lib"
  ]
  ++ lib.optional withDevdoc "devdoc";

  strictDeps = true;
  nativeBuildInputs = [
    meson
    ninja
    docbook_xsl
    pkg-config

    scdoc # for the man pages
  ]
  ++ lib.optionals withDevdoc [
    gtk-doc
  ];
  buildInputs = [
    xz
    zstd
    zlib
  ];

  mesonFlags = [
    (lib.mesonOption "sysconfdir" "/etc")
    (lib.mesonEnable "xz" true)
    (lib.mesonEnable "zstd" true)
    (lib.mesonEnable "openssl" false)
    (lib.mesonOption "modulesdirs" modulesDirs)
    (lib.mesonBool "docs" withDevdoc)
    (lib.mesonBool "manpages" true)
    (lib.mesonBool "build-tests" doCheck)
  ]
  ++ lib.optional withStatic (lib.mesonOption "default_library" "static");

  patches = [
    # Accept multiple default kernel module dirs at build-time, instead
    # of hardcoding a single (MODULE_DIRECTORY), and adjust module search logic
    # accordingly (to account for multiple default directories)
    ./module-dir.patch
    # Don't create empty confdirs at install time
    ./dont-create-empty-confdirs.patch
  ]
  # Force meson.build to support static builds
  # based on the patch from
  # https://github.com/bottlerocket-os/bottlerocket-core-kit/commit/81edc05400b05080941faed66f8ae9d5babb7ab1
  ++ lib.optional withStatic ./enable-static.patch;

  postPatch = ''
    patchShebangs scripts/
  '';

  doCheck = true;

  # The upstream Meson suite mixes pure unit tests with checks that need a
  # fake module playground and kernel-style filesystem state. Run the
  # self-contained unit tests directly instead of the full Meson suite.
  checkPhase = ''
    runHook preCheck

    ninja \
      testsuite/test-array \
      testsuite/test-blacklist \
      testsuite/test-dependencies \
      testsuite/test-depmod \
      testsuite/test-hash \
      testsuite/test-init \
      testsuite/test-initstate \
      testsuite/test-list \
      testsuite/test-loaded \
      testsuite/test-modinfo \
      testsuite/test-modprobe \
      testsuite/test-new-module \
      testsuite/test-strbuf \
      testsuite/test-util \
      testsuite/test-weakdep

    ./testsuite/test-array
    ./testsuite/test-hash
    ./testsuite/test-list
    ./testsuite/test-strbuf

    for testName in \
      test_strchr_replace \
      test_underscores \
      test_path_ends_with_kmod_ext \
      test_uadd32_overflow \
      test_uadd64_overflow \
      test_umul32_overflow \
      test_umul64_overflow \
      test_backoff_time
    do
      ./testsuite/test-util -n "$testName"
    done

    # The rest of the tests are disabled because they require extra setup
    # ./testsuite/test-blacklist
    # ./testsuite/test-dependencies
    # ./testsuite/test-depmod
    # ./testsuite/test-init
    # ./testsuite/test-initstate
    # ./testsuite/test-loaded
    # ./testsuite/test-modinfo
    # ./testsuite/test-modprobe
    # ./testsuite/test-new-module
    # ./testsuite/test-util
    # ./testsuite/test-weakdep

    runHook postCheck
  '';

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git";
    rev-prefix = "v";
  };

  meta = {
    description = "Tools for loading and managing Linux kernel modules";
    longDescription = ''
      kmod is a set of tools to handle common tasks with Linux kernel modules
      like insert, remove, list, check properties, resolve dependencies and
      aliases. These tools are designed on top of libkmod, a library that is
      shipped with kmod.
    '';
    homepage = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/";
    downloadPage = "https://www.kernel.org/pub/linux/utils/kernel/kmod/";
    changelog = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/plain/NEWS?h=v${version}";
    license = with lib.licenses; [
      lgpl21Plus
      gpl2Plus
    ]; # GPLv2+ for tools
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ artturin ];
    teams = [ lib.teams.security-review ];
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "kernel" version;
  };
}
