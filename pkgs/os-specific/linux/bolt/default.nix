{ stdenv
, meson
, ninja
, pkgconfig
, fetchFromGitLab
, python3
, umockdev
, gobject-introspection
, dbus
, asciidoc
, libxml2
, libxslt
, docbook_xml_dtd_45
, docbook_xsl
, glib
, systemd
, polkit
}:

stdenv.mkDerivation rec {
  pname = "bolt";
  version = "0.9";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "bolt";
    repo = "bolt";
    rev = version;
    sha256 = "sha256-lcJE+bMK2S2GObHMy/Fu12WGb3T1HrWjsNyZPz4/f4E=";
  };

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
    libxml2
    libxslt
    meson
    ninja
    pkgconfig
  ] ++ stdenv.lib.optional (!doCheck) python3;

  buildInputs = [
    glib
    polkit
    systemd
  ];

  doCheck = true;

  preCheck = ''
    export LD_LIBRARY_PATH=${umockdev.out}/lib/
  '';

  checkInputs = [
    dbus
    gobject-introspection
    umockdev
    (python3.withPackages
      (p: [ p.pygobject3 p.dbus-python p.python-dbusmock ]))
  ];

  # meson install tries to create /var/lib/boltd
  patches = [ ./0001-skip-mkdir.patch ];

  postPatch = ''
    patchShebangs scripts tests
  '';

  mesonFlags = [
    "-Dlocalstatedir=/var"
  ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  meta = with stdenv.lib; {
    description = "Thunderbolt 3 device management daemon";
    homepage = "https://gitlab.freedesktop.org/bolt/bolt";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ callahad ];
    platforms = platforms.linux;
  };
}
