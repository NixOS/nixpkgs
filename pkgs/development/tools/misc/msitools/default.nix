{ lib
, stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, vala
, gobject-introspection
, perl
, bison
, gettext
, glib
, pkg-config
, libgsf
, gcab
, bzip2
, gnome
}:

stdenv.mkDerivation rec {
  pname = "msitools";
  version = "0.101";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "DMTS4NEI+m8rQIW5qX3VvG2fyt7N2TPyCU+Guv2+hf4=";
  };

  patches = [
    # Fix executable bit on tools (regression in Meson migration).
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/msitools/commit/25c4353cf173cddeb76c0a2dd6621bcb753cabf8.patch";
      sha256 = "VknfZCCn4jxwn9l9noXdGczv2kV+IbOsw9cNBE67P1U=";
    })

    # Fix failure on big-endian platforms.
    # https://gitlab.gnome.org/GNOME/msitools/issues/31
    (fetchpatch {
      url = "https://gitlab.gnome.org/skitt/msitools/commit/3668c8288085d5beefae7c1387330ce9599b8365.patch";
      sha256 = "x3Mp+9TRqBAJIdzVn68HyYt0lujyMk5h5xSBUQHe9Oo=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    vala
    gobject-introspection
    perl
    bison
    gettext
    pkg-config
  ];

  buildInputs = [
    glib
    libgsf
    gcab
    bzip2
  ];

  # WiX tests fail on darwin
  doCheck = !stdenv.isDarwin;

  postPatch = ''
    patchShebangs subprojects/bats-core/{bin,libexec}
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Set of programs to inspect and build Windows Installer (.MSI) files";
    homepage = "https://wiki.gnome.org/msitools";
    license = with licenses; [
      # Library
      lgpl21Plus
      # Tools
      gpl2Plus
    ];
    maintainers = with maintainers; [ PlushBeaver ];
    platforms = platforms.unix;
  };
}
