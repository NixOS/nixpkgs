{ lib, stdenv
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
, docbook_xsl
, glib
, systemd
, polkit
}:

stdenv.mkDerivation rec {
  pname = "bolt";
  version = "0.9.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "bolt";
    repo = "bolt";
    rev = version;
    sha256 = "1phgp8fs0dlj74kbkqlvfniwc32daz47b3pvsxlfxqzyrp77xrfm";
  };

  nativeBuildInputs = [
    asciidoc
    docbook_xml_dtd_45
    docbook_xsl
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

  patches = [
    # meson install tries to create /var/lib/boltd
    ./0001-skip-mkdir.patch

    # https://github.com/NixOS/nixpkgs/issues/104429
    # Upstream issue: https://gitlab.freedesktop.org/bolt/bolt/-/issues/167
    (fetchpatch {
      name = "disable-atime-tests.diff";
      url = "https://gitlab.freedesktop.org/roberth/bolt/-/commit/1f672a7de2ebc4dd51590bb90f3b873a8ac0f4e6.diff";
      sha256 = "134f5s6kjqs6612pwq5pm1miy58crn1kxbyyqhzjnzmf9m57fnc8";
    })
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
