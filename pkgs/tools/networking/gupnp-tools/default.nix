{fetchurl, stdenv, gupnp, gssdp, pkgconfig, gtk3, libuuid, intltool, gupnp-av, gnome3, wrapGAppsHook}:

let
  pname = "gupnp-tools";
  version = "0.8.13";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1vbr4iqi7nl7kq982agd3liw10gx67s95idd0pjy5h1jsnwyqgda";
  };

  nativeBuildInputs = [ pkgconfig intltool wrapGAppsHook ];
  buildInputs = [ gupnp libuuid gssdp gtk3 gupnp-av gnome3.defaultIconTheme ];

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
