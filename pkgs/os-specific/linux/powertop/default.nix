{stdenv, fetchurl, ncurses, gettext}:

stdenv.mkDerivation {
  name = "powertop-1.11";
  src = fetchurl {
    url = http://www.lesswatts.org/projects/powertop/download/powertop-1.11.tar.gz;
    sha256 = "1wl0c7sav5rf7andnx704vs3n5gj2b5g1adx8zjfbbgvwm9wrrvh";
  };
  patches = [./powertop-1.8.patch];
  buildInputs = [ncurses gettext];
}
