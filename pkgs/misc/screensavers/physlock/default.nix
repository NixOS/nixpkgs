{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "git-20150126";
  name = "physlock-${version}";
  src = fetchFromGitHub {
    owner  = "muennich";
    repo   = "physlock";
    rev    = "b64dccc8c22710f8bf01eb5419590cdb0e65cabb";
    sha256 = "1dapkwj3y6bb4j8q4glms7zsqm7drr37nrnr30sbahwq67rnvzcc";
  };

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace "-m 4755 -o root -g root" ""
  '';

  meta = with stdenv.lib; {
    description = "A secure suspend/hibernate-friendly alternative to `vlock -an` without PAM support";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
