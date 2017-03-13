{fetchurl, stdenv, gupnp, gssdp, pkgconfig, gtk3, libuuid, intltool, gupnp_av, gnome3, gnome2, makeWrapper}:

stdenv.mkDerivation rec {
  name = "gupnp-tools-${version}";
  majorVersion = "0.8";
  version = "${majorVersion}.13";
  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-tools/${majorVersion}/gupnp-tools-${version}.tar.xz";
    sha256 = "1vbr4iqi7nl7kq982agd3liw10gx67s95idd0pjy5h1jsnwyqgda";
  };

  buildInputs = [gupnp libuuid gssdp pkgconfig gtk3 intltool gupnp_av
                 gnome2.gnome_icon_theme makeWrapper];

  postInstall = ''
    for program in gupnp-av-cp gupnp-universal-cp; do
      wrapProgram "$out/bin/$program" \
        --prefix XDG_DATA_DIRS : "${gtk3.out}/share:${gnome3.gnome_themes_standard}/share:${gnome2.gnome_icon_theme}/share:$out/share"
    done
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
