{ lib, stdenv, fetchFromGitLab, meson, mesonEmulatorHook, ninja, glib, check, python3, vala, gtk-doc, glibcLocales
, libxml2, libxslt, pkg-config, sqlite, docbook_xsl, docbook_xml_dtd_43, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "libaccounts-glib";
  version = "1.24";

  outputs = [ "out" "dev" "devdoc" "py" ];

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "libaccounts-glib";
    rev = version;
    sha256 = "0y8smg1rd279lrr9ad8b499i8pbkajmwd4xn41rdh9h93hs9apn7";
  };

  # See: https://gitlab.com/accounts-sso/libaccounts-glib/merge_requests/22
  patches = [ ./py-override.patch ];

  nativeBuildInputs = [
    check
    docbook_xml_dtd_43
    docbook_xsl
    glibcLocales
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
    vala
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];

  buildInputs = [
    glib
    libxml2
    libxslt
    python3.pkgs.pygobject3
    sqlite
  ];

  # TODO: send patch upstream to make running tests optional
  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    substituteInPlace meson.build \
      --replace "subdir('tests')" ""
  '';

  LC_ALL = "en_US.UTF-8";

  mesonFlags = [
    "-Dpy-overrides-dir=${placeholder "py"}/${python3.sitePackages}/gi/overrides"
  ];

  meta = with lib; {
    description = "Library for managing accounts which can be used from GLib applications";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
