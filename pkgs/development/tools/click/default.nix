{
  lib,
  fetchFromGitLab,
  fetchpatch,
  stdenv,
  buildPythonApplication,
  autoreconfHook,
  dbus,
  dbus-test-runner,
  dpkg,
  glib,
  python-debian,
  python-apt,
  perl,
  vala,
  pkg-config,
  libgee,
  json-glib,
  properties-cpp,
  gobject-introspection,
  getopt,
  setuptools,
  six,
  pygobject3,
  unittestCheckHook,
  wrapGAppsHook3,
}:

buildPythonApplication rec {
  pname = "click";
  version = "0.5.2";
  format = "other";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/click";
    rev = version;
    hash = "sha256-AV3n6tghvpV/6Ew6Lokf8QAGBIMbHFAnp6G4pefVn+8=";
  };

  postPatch = ''
    # These should be proper Requires, using the header needs their headers
    substituteInPlace lib/click/click-*.pc.in \
      --replace-fail 'Requires.private' 'Requires'

    # Don't completely override PKG_CONFIG_PATH
    substituteInPlace click_package/tests/Makefile.am \
      --replace-fail 'PKG_CONFIG_PATH=$(top_builddir)/lib/click' 'PKG_CONFIG_PATH=$(top_builddir)/lib/click:$(PKG_CONFIG_PATH)'

    patchShebangs bin/click
  '';

  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ];

  preFixup = ''
    makeWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "$out/lib"
    )
  '';

  preConfigure = ''
    export click_cv_perl_vendorlib=$out/${perl.libPrefix}
    export PYTHON_INSTALL_FLAGS="--prefix=$out"
  '';

  strictDeps = true;

  pkgsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    autoreconfHook
    dbus-test-runner # Always checking for this
    perl
    pkg-config
    gobject-introspection
    vala
    getopt
    wrapGAppsHook3
  ];

  nativeCheckInputs = [
    dbus
    dpkg
    unittestCheckHook
  ];

  checkInputs = [
    python-apt
    six
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export HOME=$TMP

    # tests recompile some files for loaded predefines, doesn't use any optimisation level for it
    # makes test output harder to read, so make the warning go away
    export NIX_CFLAGS_COMPILE+=" -U_FORTIFY_SOURCE"

    for path in $disabledTestPaths; do
      rm -v $path
    done
  '';

  disabledTestPaths = [
    # From apt: Unable to determine a suitable packaging system type
    "click_package/tests/integration/test_signatures.py"
    "click_package/tests/test_build.py"
    "click_package/tests/test_install.py"
    "click_package/tests/test_scripts.py"
  ];

  enableParallelBuilding = true;

  patches = [
    # Remove when version > 0.5.2
    (fetchpatch {
      name = "0001-click-fix-Wimplicit-function-declaration.patch";
      url = "https://gitlab.com/ubports/development/core/click/-/commit/8f654978a12e6f9a0b6ff64296ec5565e3ff5cd0.patch";
      hash = "sha256-kio+DdtuagUNYEosyQY3q3H+dJM3cLQRW9wUKUcpUTY=";
    })

    # Remove when version > 0.5.2
    (fetchpatch {
      name = "0002-click-Add-uid_t-and-gid_t-to-the-ctypes-_typemap.patch";
      url = "https://gitlab.com/ubports/development/core/click/-/commit/cbcd23b08b02fa122434e1edd69c2b3dcb6a8793.patch";
      hash = "sha256-QaWRhxO61wAzULVqPLdJrLuBCr3+NhKmQlEPuYq843I=";
    })
  ];

  buildInputs = [
    glib
    libgee
    json-glib
    properties-cpp
  ];

  propagatedBuildInputs = [
    python-debian
    pygobject3
    setuptools
  ];

  meta = {
    description = "Tool to build click packages. Mainly used for Ubuntu Touch";
    homepage = "https://gitlab.com/ubports/development/core/click";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ilyakooo0
      OPNA2608
    ];
    platforms = lib.platforms.linux;
  };
}
