{ stdenv
, lib
, pkg-config
, meson
, ninja
, fetchFromGitLab
, fetchpatch
, libgudev
, glib
, polkit
, gobject-introspection
, gettext
, gtk-doc
, docbook-xsl-nons
, docbook_xml_dtd_412
, libxml2
, libxslt
, upower
, umockdev
, systemd
, python3
, wrapGAppsNoGuiHook
, nixosTests
}:

let
  testPythonPkgs = ps: with ps; [
    pygobject3
    dbus-python
    python-dbusmock
  ];
  testTypelibPath = lib.makeSearchPathOutput "lib" "lib/girepository-1.0" [ umockdev ];
in
stdenv.mkDerivation rec {
  pname = "power-profiles-daemon";
  version = "0.10.1";

  outputs = [ "out" "devdoc" "installedTests" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "power-profiles-daemon";
    rev = version;
    sha256 = "sha256-sQWiCHc0kEELdmPq9Qdk7OKDUgbM5R44639feC7gjJc=";
  };

  patches = [
    # Enable installed tests.
    # https://gitlab.freedesktop.org/hadess/power-profiles-daemon/-/merge_requests/92
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/hadess/power-profiles-daemon/-/commit/3c64d9e1732eb6425e33013c452f1c4aa7a26f7e.patch";
      sha256 = "din5VuZZwARNDInHtl44yJK8pLmlxr5eoD4iMT4a8HA=";
    })

    # Install installed tests to separate output.
    ./installed-tests-path.patch
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    gtk-doc
    docbook-xsl-nons
    docbook_xml_dtd_412
    libxml2 # for xmllint for stripping GResources
    libxslt # for xsltproc for building docs
    gobject-introspection
    wrapGAppsNoGuiHook
    python3.pkgs.wrapPython

    # For finding tests.
    (python3.withPackages testPythonPkgs)
  ];

  buildInputs = [
    libgudev
    systemd
    upower
    glib
    polkit
    python3 # for cli tool
  ];

  strictDeps = true;

  # for cli tool
  pythonPath = [
    python3.pkgs.pygobject3
  ];

  mesonFlags = [
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dgtk_doc=true"
  ];

  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  # Avoid double wrapping
  dontWrapGApps = true;

  postPatch = ''
    patchShebangs tests/unittest_inspector.py
  '';

  preConfigure = ''
    # For finding tests.
    GI_TYPELIB_PATH_original=$GI_TYPELIB_PATH
    addToSearchPath GI_TYPELIB_PATH "${testTypelibPath}"
  '';

  postConfigure = ''
    # Restore the original value to prevent the program from depending on umockdev.
    export GI_TYPELIB_PATH=$GI_TYPELIB_PATH_original
    unset GI_TYPELIB_PATH_original
  '';

  preInstall = ''
    # We have pkexec on PATH so Meson will try to use it when installation fails
    # due to being unable to write to e.g. /etc.
    # Let’s pretend we already ran pkexec –
    # the pkexec on PATH would complain it lacks setuid bit,
    # obscuring the underlying error.
    # https://github.com/mesonbuild/meson/blob/492cc9bf95d573e037155b588dc5110ded4d9a35/mesonbuild/minstall.py#L558
    export PKEXEC_UID=-1
  '';

  postFixup = ''
    # Avoid double wrapping
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    # Make Python libraries available
    wrapPythonProgramsIn "$out/bin" "$pythonPath"

    # Make Python libraries available for installed tests
    makeWrapperArgs+=(
      --prefix GI_TYPELIB_PATH : "${testTypelibPath}"
      --prefix PATH : "${lib.makeBinPath [ umockdev ]}"
      # Vala does not use absolute paths in typelibs
      # https://github.com/NixOS/nixpkgs/issues/47226
      # Also umockdev binaries use relative paths for LD_PRELOAD.
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ umockdev ]}"
      # dbusmock calls its templates using exec so our regular patching of Python scripts
      # to add package directories to site will not carry over.
      # https://github.com/martinpitt/python-dbusmock/blob/2254e69279a02fb3027b500ed7288b77c7a80f2a/dbusmock/mockobject.py#L51
      # https://github.com/martinpitt/python-dbusmock/blob/2254e69279a02fb3027b500ed7288b77c7a80f2a/dbusmock/__main__.py#L60-L62
      --prefix PYTHONPATH : "${lib.makeSearchPath python3.sitePackages (testPythonPkgs python3.pkgs)}"
    )
    wrapPythonProgramsIn "$installedTests/libexec/installed-tests" "$pythonPath ${lib.concatStringsSep " " (testPythonPkgs python3.pkgs)}"
  '';

  passthru = {
    tests = {
      nixos = nixosTests.power-profiles-daemon;
      installed-tests = nixosTests.installed-tests.power-profiles-daemon;
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/hadess/power-profiles-daemon";
    description = "Makes user-selected power profiles handling available over D-Bus";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar mvnetbiz ];
  };
}
