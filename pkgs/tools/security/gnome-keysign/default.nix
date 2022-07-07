{ lib
, fetchFromGitLab
, fetchpatch
, python3
, wrapGAppsHook
, gobject-introspection
, gtk3
, glib
, gst_all_1
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-keysign";
  version = "1.2.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    sha256 = "1sjphi1lsivg9jmc8khbcqa9w6608pkrccz4nz3rlcc54hn0k0sj";
  };

  patches = [
    # fix build failure due to missing import
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-keysign/commit/216c3677e68960afc517edc00529323e85909323.patch";
      sha256 = "1w410gvcridbq26sry7fxn49v59ss2lc0w5ab7csva8rzs1nc990";
    })

    # stop requiring lxml (no longer used)
    # https://gitlab.gnome.org/GNOME/gnome-keysign/merge_requests/23
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-keysign/commit/ffc6f40584d7564951e1c8b6d18d4f8a6a3fa09d.patch";
      sha256 = "1hs6mmhi2f21kvy26llzvp37yf0i0dr69d18r641139nr6qg6kwy";
      includes = [ "setup.py" ];
    })
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ] ++ (with python3.pkgs; [
    babel
    babelgladeextractor
  ]);

  buildInputs = [
    # TODO: add avahi support
    gtk3
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    (gst_all_1.gst-plugins-bad.override { enableZbar = true; }) # for zbar plug-in
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

  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  # bunch of linting
  doCheck = false;

  meta = with lib; {
    description = "GTK/GNOME application to use GnuPG for signing other peoples’ keys";
    homepage = "https://wiki.gnome.org/Apps/Keysign";
    license = licenses.gpl3Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
