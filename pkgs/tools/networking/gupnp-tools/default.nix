{fetchurl, stdenv, gupnp, gssdp, pkgconfig, gtk3, libuuid, intltool, gupnp_av, gnome3, makeWrapper}:

stdenv.mkDerivation rec {
  name = "gupnp-tools-${version}";
  majorVersion = "0.8";
  version = "${majorVersion}.8";
  src = fetchurl {
    url = "mirror://gnome/sources/gupnp-tools/${majorVersion}/gupnp-tools-${version}.tar.xz";
    sha256 = "160dgh9pmlb85qfavwqz46lqawpshs8514bx2b57f9rbiny8kbij";
  };

  buildInputs = [gupnp libuuid gssdp pkgconfig gtk3 intltool gupnp_av gnome3.gnome_icon_theme gnome3.gnome_themes_standard makeWrapper];

  postInstall = ''
    wrapProgram "$out/bin/gupnp-av-cp" --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:${gnome3.gnome_icon_theme}/share:$out/share"
    wrapProgram "$out/bin/gupnp-universal-cp" --prefix XDG_DATA_DIRS : "${gtk3}/share:${gnome3.gnome_themes_standard}/share:${gnome3.gnome_icon_theme}/share:$out/share"
  '';
}
