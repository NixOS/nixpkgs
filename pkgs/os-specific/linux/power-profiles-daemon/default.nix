{ stdenv
, lib
, pkg-config
, meson
, mesonEmulatorHook
, ninja
, fetchFromGitLab
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
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "power-profiles-daemon";
  version = "0.20";

  outputs = [ "out" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "upower";
    repo = "power-profiles-daemon";
    rev = version;
    sha256 = "sha256-8wSRPR/1ELcsZ9K3LvSNlPcJvxRhb/LRjTIxKtdQlCA=";
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
    # checkInput but cheked for during the configuring
    (python3.pythonOnBuildForHost.withPackages (ps: with ps; [
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
    # for cli tool
    (python3.withPackages (ps: [
      ps.pygobject3
    ]))
  ];

  strictDeps = true;

  checkInputs = [
    umockdev
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

  postPatch = ''
    patchShebangs --build \
      tests/integration-test.py \
      tests/unittest_inspector.py

    patchShebangs --host \
      src/powerprofilesctl
  '';

  passthru = {
    tests = {
      nixos = nixosTests.power-profiles-daemon;
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/hadess/power-profiles-daemon";
    description = "Makes user-selected power profiles handling available over D-Bus";
    mainProgram = "powerprofilesctl";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
