{ lib, stdenv
, fetchFromGitLab
, fetchpatch
, pkg-config
, gobject-introspection
, meson
, ninja
, perl
, gettext
, cairo
, gtk-doc
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_412
, fetchurl
, glib
, gusb
, dbus
, polkit
, nss
, pam
, systemd
, libfprint
, python3
}:

stdenv.mkDerivation rec {
  pname = "fprintd";
  version = "1.94.2";
  outputs = [ "out" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libfprint";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ePhcIZyXoGr8XlBuzKjpibU9D/44iCXYBlpVR9gcswQ=";
  };

  patches = [
    # backport upstream patch fixing tests
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/commit/ae04fa989720279e5558c3b8ff9ebe1959b1cf36.patch";
      sha256 = "sha256-jW5vlzrbZQ1gUDLBf7G50GnZfZxhlnL2Eu+9Bghdwdw=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    perl # for pod2man
    gettext
    gtk-doc
    libxslt
    dbus
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  buildInputs = [
    glib
    polkit
    nss
    pam
    systemd
    libfprint
  ];

  checkInputs = with python3.pkgs; [
    gobject-introspection # for setup hook
    python-dbusmock
    dbus-python
    pygobject3
    pycairo
    pypamtest
    gusb # Required by libfprint’s typelib
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dpam_modules_dir=${placeholder "out"}/lib/security"
    "-Dsysconfdir=${placeholder "out"}/etc"
    "-Ddbus_service_dir=${placeholder "out"}/share/dbus-1/system-services"
    "-Dsystemd_system_unit_dir=${placeholder "out"}/lib/systemd/system"
  ];

  PKG_CONFIG_DBUS_1_INTERFACES_DIR = "${placeholder "out"}/share/dbus-1/interfaces";
  PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";
  PKG_CONFIG_DBUS_1_DATADIR = "${placeholder "out"}/share";

  # FIXME: Ugly hack for tests to find libpam_wrapper.so
  LIBRARY_PATH = lib.makeLibraryPath [ python3.pkgs.pypamtest ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      po/check-translations.sh \
      tests/unittest_inspector.py
  '';

  meta = with lib; {
    homepage = "https://fprint.freedesktop.org/";
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
