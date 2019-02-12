{fetchurl, fetchpatch, stdenv, meson, ninja, gupnp, gssdp, pkgconfig, gtk3, libuuid, gettext, gupnp-av, gtksourceview4, gnome3, wrapGAppsHook}:

stdenv.mkDerivation rec {
  pname = "gupnp-tools";
  version = "0.8.15";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1awpqjs08cf6aimvzldnlnz5zmdyw8aq4k2rl5239j4zkfhg8vik";
  };

  patches = [
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/gupnp-tools/commit/2845d07b1584789a23a0e691ceff476e5d82ccb7.patch;
      sha256 = "1a8bhsz41s27kbaxp9jbmbisabin6lz2ln87012syvi6f2s332hv";
    })
  ];

  nativeBuildInputs = [ meson ninja pkgconfig gettext wrapGAppsHook ];
  buildInputs = [ gupnp libuuid gssdp gtk3 gupnp-av gtksourceview4 gnome3.defaultIconTheme ];

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
