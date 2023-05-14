{ stdenv
, lib
, pkg-config
, meson
, mesonEmulatorHook
, ninja
, fetchFromGitLab
, fetchpatch
, libgudev
, glib
, polkit
, dbus
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

stdenv.mkDerivation rec {
  pname = "power-profiles-daemon";
  version = "0.12";

  outputs = [ "out" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "power-profiles-daemon";
    rev = version;
    sha256 = "sha256-2eMFPGVLwTBIlaB1zM3BzHrhydgBEm+kvx+VIZdUDPM=";
  };

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
    # checkInput but cheked for during the configuring
    (python3.pythonForBuild.withPackages (ps: with ps; [
      pygobject3
      dbus-python
      python-dbusmock
    ]))
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    libgudev
    systemd
    upower
    glib
    polkit
    python3 # for cli tool
    # Duplicate from nativeCheckInputs until https://github.com/NixOS/nixpkgs/issues/161570 is solved
    umockdev
  ];

  strictDeps = true;

  # for cli tool
  pythonPath = [
    python3.pkgs.pygobject3
  ];

  nativeCheckInputs = [
    umockdev
    dbus
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dgtk_doc=true"
    "-Dtests=${lib.boolToString (stdenv.buildPlatform.canExecute stdenv.hostPlatform)}"
  ];

  doCheck = true;

  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  # Avoid double wrapping
  dontWrapGApps = true;

  postPatch = ''
    patchShebangs --build \
      tests/integration-test.py \
      tests/unittest_inspector.py
  '';

  postCheck = ''
    # Do not contaminate the wrapper with test dependencies.
    unset GI_TYPELIB_PATH
    unset XDG_DATA_DIRS
  '';

  postFixup = ''
    # Avoid double wrapping
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    # Make Python libraries available
    wrapPythonProgramsIn "$out/bin" "$pythonPath"
  '';

  passthru = {
    tests = {
      nixos = nixosTests.power-profiles-daemon;
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
