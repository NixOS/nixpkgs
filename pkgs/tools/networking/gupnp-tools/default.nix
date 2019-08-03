{ stdenv
, fetchurl
, meson
, ninja
, gupnp
, gssdp
, pkgconfig
, gtk3
, libuuid
, gettext
, gupnp-av
, gtksourceview4
, gnome3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gupnp-tools";
  version = "0.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "13d1qr1avz9r76989nvgxhhclmqzr025xjk4rfnja94fpbspznj1";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gettext
    wrapGAppsHook
  ];

  buildInputs = [
    gupnp
    libuuid
    gssdp
    gtk3
    gupnp-av
    gtksourceview4
    gnome3.adwaita-icon-theme
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Set of utilities and demos to work with UPnP";
    homepage = https://wiki.gnome.org/Projects/GUPnP;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
