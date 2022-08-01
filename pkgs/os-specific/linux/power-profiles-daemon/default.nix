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

let
  testPythonPkgs = ps: with ps; [
    pygobject3
    dbus-python
    python-dbusmock
  ];
in
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
  ];

  buildInputs = [
    libgudev
    systemd
    upower
    glib
    polkit
    python3 # for cli tool
    # Duplicate from checkInputs until https://github.com/NixOS/nixpkgs/issues/161570 is solved
    umockdev
  ];

  strictDeps = true;

  # for cli tool
  pythonPath = [
    python3.pkgs.pygobject3
  ];

  checkInputs = [
    umockdev
    dbus
    (python3.withPackages testPythonPkgs)
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "-Dgtk_doc=true"
    "-Dtests=true"
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

  preInstall = ''
    # We have pkexec on PATH so Meson will try to use it when installation fails
    # due to being unable to write to e.g. /etc.
    # Let’s pretend we already ran pkexec –
    # the pkexec on PATH would complain it lacks setuid bit,
    # obscuring the underlying error.
    # https://github.com/mesonbuild/meson/blob/492cc9bf95d573e037155b588dc5110ded4d9a35/mesonbuild/minstall.py#L558
    export PKEXEC_UID=-1
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
