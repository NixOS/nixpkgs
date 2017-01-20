{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "0.5";
  name = "physlock-v${version}";
  src = fetchFromGitHub {
    owner = "muennich";
    repo = "physlock";
    rev = "v${version}";
    sha256 = "102kdixrf7xxsxr69lbz73i1ss7959716cmdf8d5kbnhmk6argv7";
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
