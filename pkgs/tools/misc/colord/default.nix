{ stdenv
, fetchurl
, bash-completion
, glib
, polkit
, pkgconfig
, gettext
, gusb
, lcms2
, sqlite
, systemd
, dbus
, gobject-introspection
, argyllcms
, meson
, ninja
, libxml2
, vala
, libgudev
, wrapGAppsHook
, shared-mime-info
, sane-backends
, docbook_xsl
, docbook_xsl_ns
, docbook_xml_dtd_412
, gtk-doc
, libxslt
, substituteAll
}:

stdenv.mkDerivation rec {
  pname = "colord";
  version = "1.4.4";

  outputs = [ "out" "dev" "devdoc" "man" "installedTests" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/colord/releases/${pname}-${version}.tar.xz";
    sha256 = "19f0938fr7nvvm3jr263dlknaq7md40zrac2npfyz25zc00yh3ws";
  };

  patches = [
    # Put installed tests into its own output
    ./installed-tests-path.patch
  ];

  postPatch = ''
    for file in data/tests/meson.build lib/colord/cd-test-shared.c lib/colord/meson.build; do
        substituteInPlace $file --subst-var-by installed_tests_dir "$installedTests"
    done
  '';

  mesonFlags = [
    "--localstatedir=/var"
    "-Dinstalled_tests=true"
    "-Dlibcolordcompat=true"
    "-Dsane=true"
    "-Dvapi=true"
    "-Ddaemon_user=colord"
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_412
    docbook_xsl
    docbook_xsl_ns
    gettext
    gobject-introspection
    gtk-doc
    libxslt
    meson
    ninja
    pkgconfig
    shared-mime-info
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    argyllcms
    bash-completion
    dbus
    glib
    gusb
    lcms2
    libgudev
    polkit
    sane-backends
    sqlite
    systemd
  ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";
  PKG_CONFIG_SYSTEMD_TMPFILESDIR = "${placeholder "out"}/lib/tmpfiles.d";
  PKG_CONFIG_BASH_COMPLETION_COMPLETIONSDIR= "${placeholder "out"}/share/bash-completion/completions";
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  meta = with stdenv.lib; {
    description = "System service to manage, install and generate color profiles to accurately color manage input and output devices";
    homepage = https://www.freedesktop.org/software/colord/;
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.marcweber ];
    platforms = platforms.linux;
  };
}
