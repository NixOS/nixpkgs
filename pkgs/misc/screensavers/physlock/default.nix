{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "git-20151025";
  name = "physlock-${version}";
  src = fetchFromGitHub {
    owner  = "muennich";
    repo   = "physlock";
    rev    = "d47a885a1100a7ef2d949f7763f6249711efbb9e";
    sha256 = "1ln5lpfzx4s7val921drm2db22g9klsinpg5lg8hccf689myhk0m";
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
