{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "alsa-lib-1.0.14";
  src = fetchurl {
    url = ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.14.tar.bz2;
	sha256 = "18xhm53adgss20jnva2nfl9gk46kb5an6ah820pazqn0ykd97rh1";
  };

  meta = {
	  homepage = http://www.alsa-project.org;
  };
}
