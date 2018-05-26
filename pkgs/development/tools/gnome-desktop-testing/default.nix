{ stdenv, glib, autoreconfHook, pkgconfig, systemd, fetchgit }:

stdenv.mkDerivation rec {
  version = "2018.1";
  name = "gnome-desktop-testing-${version}";

  src = fetchgit {
    url = https://git.gnome.org/browse/gnome-desktop-testing;
    rev = "v${version}";
    sha256 = "1bcd8v101ynsv2p5swh30hnajjf6z8dxzd89h9racp847hgjgyxc";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ glib systemd ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "GNOME OSTree testing code";
    homepage = https://live.gnome.org/Initiatives/GnomeGoals/InstalledTests;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.jtojnar ];
  };
}
