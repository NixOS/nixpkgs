{ stdenv
, lib
, meson
, ninja
, pkg-config
, fetchFromGitLab
, fetchpatch
, python3
, umockdev
, gobject-introspection
, dbus
, asciidoc
, libxml2
, libxslt
, docbook_xml_dtd_45
, docbook-xsl-nons
, glib
, systemd
, polkit
}:

stdenv.mkDerivation rec {
  pname = "bolt";
  version = "0.9.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "bolt";
    repo = "bolt";
    rev = version;
    sha256 = "eXjj7oD5HOW/AG2uxDa0tSleKmbouFd2fwlL2HHFiMA=";
  };

  patches = [
    # meson install tries to create /var/lib/boltd
    ./0001-skip-mkdir.patch

    # Test does not work on ZFS with atime disabled.
    # Upstream issue: https://gitlab.freedesktop.org/bolt/bolt/-/issues/167
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/bolt/bolt/-/commit/c2f1d5c40ad71b20507e02faa11037b395fac2f8.diff";
      revert = true;
      sha256 = "6w7ll65W/CydrWAVi/qgzhrQeDv1PWWShulLxoglF+I=";
    })
  ];

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook-xsl-nons
    libxml2
    libxslt
    meson
    ninja
    pkg-config
  ] ++ lib.optional (!doCheck) python3;

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

  postPatch = ''
    patchShebangs scripts tests
  '';

  mesonFlags = [
    "-Dlocalstatedir=/var"
  ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  meta = with lib; {
    description = "Thunderbolt 3 device management daemon";
    homepage = "https://gitlab.freedesktop.org/bolt/bolt";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ callahad ];
    platforms = platforms.linux;
  };
}
