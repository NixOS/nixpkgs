{ stdenv
, fetchFromGitLab
, python3
, wrapGAppsHook
, gobject-introspection
, gtk3
, glib
, gnome3
, gst_all_1
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-keysign";
  version = "1.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "0iy70dskd7wly37lpb2ypd9phhyml5j3c7rzajii4f2s7zgb3abg";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ] ++ (with python3.pkgs; [
    Babel
    lxml
  ]);

  buildInputs = [
    # TODO: add avahi support
    gtk3
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    gst_all_1.gst-plugins-bad # for zbar plug-in
  ];

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python
    future
    gpgme
    magic-wormhole
    pygobject3
    pybluez
    qrcode
    requests
    twisted
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  # bunch of linting
  doCheck = false;

  meta = with stdenv.lib; {
    description = "GTK/GNOME application to use GnuPG for signing other peoples’ keys";
    homepage = https://wiki.gnome.org/Apps/Keysign;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
