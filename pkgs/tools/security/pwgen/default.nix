{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "pwgen-2.07";

  src = fetchurl {
    url = mirror://sourceforge/pwgen/pwgen-2.07.tar.gz;
    sha256 = "0mhmw700kkh238fzivcwnwi94bj9f3h36yfh3k3j2v19b0zmjx7b";
  };
  meta = {
    description = "Password generator which creates passwords which can be easily memorized by a human";
    platforms = stdenv.lib.platforms.all;
  };
}
