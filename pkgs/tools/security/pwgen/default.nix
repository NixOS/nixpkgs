{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "pwgen-2.06";

  src = fetchurl {
    url = mirror://sourceforge/pwgen/pwgen-2.06.tar.gz;
    sha256 = "0m1lhkcyizisksr1vlqysjkickrca9qwqkkx6vkv4zhg7ag8qnb1";
  };
  meta = {
    description = "Password generator which creates passwords which can be easily memorized by a human";
    platforms = stdenv.lib.platforms.all;
  };
}
