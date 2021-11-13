{ stdenv
, lib
, fetchurl
, fetchpatch
, meson
, ninja
, gupnp
, gssdp
, pkg-config
, gtk3
, libuuid
, gettext
, gupnp-av
, gtksourceview4
, gnome
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gupnp-tools";
  version = "0.10.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "TqltFnRis6VI78T8TqCJ/lGNfSm+NJ0czomCuf+1O0o=";
  };

  patches = [
    # Fix compilation with -Werror=format-security.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gupnp-tools/commit/d738baae3bffaf6a8dfc12f5fe1ea13168fe2e48.patch";
      sha256 = "wrORH4y9Yb0YGAsjzoeN2MM07y9o+91kx078RH0G76w=";
    })
    # Fix missing variable reference caused by the previous patch.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gupnp-tools/commit/9b852d91175bc7607ad845459ba29d07a16fcbce.patch";
      sha256 = "WjEBN/+snJSIg4SUP5iChdj2auIyzePI0TH3Ilks7fk=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    gnome.adwaita-icon-theme
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Set of utilities and demos to work with UPnP";
    homepage = "https://wiki.gnome.org/Projects/GUPnP";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
