{ stdenv, glib, autoreconfHook, pkgconfig, systemd, fetchgit }:

stdenv.mkDerivation rec {
  version = "2018.1";
  pname = "gnome-desktop-testing";

  src = fetchgit {
    url = https://gitlab.gnome.org/GNOME/gnome-desktop-testing.git;
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
