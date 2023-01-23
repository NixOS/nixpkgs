{ lib
, stdenv
, fetchFromGitHub
, glib
, gtk3
, json-glib
, sqlite
, libsoup
, liboauth
, gettext
, gspell
, vala
, meson
, ninja
, pkg-config
, dconf
, gst_all_1
, wrapGAppsHook
, gobject-introspection
, glib-networking
, librest
, python3
}:

stdenv.mkDerivation rec {
  version = "1.5";
  pname = "cawbird";

  src = fetchFromGitHub {
    owner = "IBBoard";
    repo = "cawbird";
    rev = "v${version}";
    sha256 = "sha256-XFN9gfCoQDmYYysg1yrUoPPE0Ow40LttvV5Ltu0DTfI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook
    python3
    gobject-introspection # for setup hook
  ];

  buildInputs = [
    glib
    gtk3
    json-glib
    sqlite
    libsoup
    liboauth
    gettext
    dconf
    gspell
    glib-networking
    librest
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    (gst-plugins-good.override {
      gtkSupport = true;
    })
    gst-libav
  ]);

  postPatch = ''
    chmod +x data/meson_post_install.py # patchShebangs requires executable file
    patchShebangs data/meson_post_install.py
  '';

  # supply Twitter API keys
  # use keys supplied by @SuperSandro2000, see https://github.com/IBBoard/cawbird/blob/master/README.md#preparation
  mesonFlags = [
    "-Dconsumer_key_base64=YnJJNm01SE9PbEkzM3pWenZObVhVSHdlTg=="
    "-Dconsumer_secret_base64=YUc1SkcyYzhsenlKT2VOWWhVSXlJMERDaFh0WEswUG9oTEp4TzhZNEdJb1hXN0hhYlY="
  ];

  meta = with lib; {
    description = "Native GTK Twitter client for the Linux desktop";
    longDescription = "Cawbird is a modern, easy and fun Twitter client. Fork of the discontinued Corebird.";
    homepage = "https://ibboard.co.uk/cawbird/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ jonafato schmittlauch SuperSandro2000 ];
  };
}
