{fetchurl, stdenv, gupnp, gssdp, pkgconfig, gtk3, libuuid, intltool, gupnp-av, gnome3, wrapGAppsHook}:

let
  pname = "gupnp-tools";
  version = "0.8.14";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1ykybsljjnngj8rsn808a0h37r2jx99c2jbmsb3ihf7l7hmraav8";
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
