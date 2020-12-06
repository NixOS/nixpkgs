{ stdenv
, fetchFromGitLab
, fetchpatch
, pkgconfig
, meson
, ninja
, perl
, gettext
, cairo
, gtk-doc
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_412
, glib
, dbus
, dbus-glib
, polkit
, nss
, pam
, systemd
, libfprint
, python3
}:

stdenv.mkDerivation rec {
  pname = "fprintd";
  version = "1.90.1";
  outputs = [ "out" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "libfprint";
    repo = pname;
    rev = version;
    sha256 = "0mbzk263x7f58i9cxhs44mrngs7zw5wkm62j5r6xlcidhmfn03cg";
  };

  patches = [
    # Fixes issue with ":" when there is multiple paths (might be the case on NixOS)
    # https://gitlab.freedesktop.org/libfprint/fprintd/-/merge_requests/50
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/commit/d7fec03f24d10f88d34581c72f0eef201f5eafac.patch";
      sha256 = "0f88dhizai8jz7hpm5lpki1fx4593zcy89iwi4brsqbqc7jp9ls0";
    })

    # Fix locating libpam_wrapper for tests
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/merge_requests/40.patch";
      sha256 = "0qqy090p93lzabavwjxzxaqidkcb3ifacl0d3yh1q7ms2a58yyz3";
    })
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/commit/f401f399a85dbeb2de165b9b9162eb552ab6eea7.patch";
      sha256 = "1bc9g6kc95imlcdpvp8qgqjsnsxg6nipr6817c1pz5i407yvw1iy";
    })
  ];

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    perl
    gettext
    gtk-doc
    libxslt
    dbus
    docbook-xsl-nons
    docbook_xml_dtd_412
  ];

  buildInputs = [
    glib
    dbus-glib
    polkit
    nss
    pam
    systemd
    libfprint
  ];

  checkInputs = with python3.pkgs; [
    python-dbusmock
    dbus-python
    pygobject3
    pycairo
    pypamtest
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
  LIBRARY_PATH = stdenv.lib.makeLibraryPath [ python3.pkgs.pypamtest ];

  doCheck = true;

  postPatch = ''
    patchShebangs po/check-translations.sh
  '';

  meta = with stdenv.lib; {
    homepage = "https://fprint.freedesktop.org/";
    description = "D-Bus daemon that offers libfprint functionality over the D-Bus interprocess communication bus";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar elyhaka ];
  };
}
