{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "powertop-1.9";
  src = fetchurl {
    url = http://www.lesswatts.org/projects/powertop/download/powertop-1.9.tar.gz;
    sha256 = "15150ra7n0q1nfij4ax3dnlplyjakm2ipx246xi3wsj3qc99m2a1";
  };
  patches = [./powertop-1.8.patch];
  buildInputs = [ncurses];
}
