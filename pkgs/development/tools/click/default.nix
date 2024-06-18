{ lib
, fetchFromGitLab
, buildPythonApplication
, autoreconfHook
, debian
, perl
, vala
, pkg-config
, libgee
, json-glib
, properties-cpp
, gobject-introspection
, getopt
, setuptools
, pygobject3
, wrapGAppsHook3
}:

buildPythonApplication {
  pname = "click";
  version = "unstable-2023-02-22";
  format = "other";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/click";
    rev = "aaf2735e8e6cbeaf2e429c70136733513a81718a";
    sha256 = "sha256-pNu995/w3tbz15QQVdVYBnWnAoZmqWj1DN/5PZZ0iZw=";
  };

  postPatch = ''
    # These should be proper Requires, using the header needs their headers
    substituteInPlace lib/click/click-*.pc.in \
      --replace 'Requires.private' 'Requires'
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

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
    gobject-introspection
    vala
    getopt
    wrapGAppsHook3
  ];

  # Tests were omitted for time constraint reasons
  doCheck = false;

  enableParallelBuilding = true;

  patches = [
    # dbus-test-runner not packaged yet, otherwise build-time dependency even when not running tests
    ./dbus-test-runner.patch
  ];

  buildInputs = [
    libgee
    json-glib
    properties-cpp
  ];

  propagatedBuildInputs = [
    debian
    pygobject3
    setuptools
  ];

  meta = {
    description = "Tool to build click packages. Mainly used for Ubuntu Touch";
    homepage = "https://gitlab.com/ubports/development/core/click";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ilyakooo0 OPNA2608 ];
    platforms = lib.platforms.linux;
  };
}
