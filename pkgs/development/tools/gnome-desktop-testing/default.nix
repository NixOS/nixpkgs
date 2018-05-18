{ stdenv, glib, autoreconfHook, pkgconfig, libgsystem, fetchgit }:

stdenv.mkDerivation rec {
  version = "2016.1";
  name = "gnome-desktop-testing-${version}";

  src = fetchgit {
    url = https://git.gnome.org/browse/gnome-desktop-testing;
    rev = "v${version}";
    sha256 = "18qhmsab6jc01qrfzjx8m4799gbs72c4jg830mp0p865rcbl68dc";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ glib libgsystem ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GNOME OSTree testing code";
    homepage = https://live.gnome.org/Initiatives/GnomeGoals/InstalledTests;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.jtojnar ];
  };
}
