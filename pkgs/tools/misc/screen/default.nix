{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "screen-4.0.2";
  src = fetchurl {
    url = mirror://gnu/screen/screen-4.0.2.tar.gz;
    md5 = "ed68ea9b43d9fba0972cb017a24940a1";
  };

  buildInputs = [ncurses];
}
