{ stdenv, fetchurl  }:

stdenv.mkDerivation rec {
  version = "0.5";
  name = "physlock-v${version}";
  src = fetchurl {
    url = "http://github.com/muennich/physlock/archive/v${version}.tar.gz";
    sha256 = "10l7amxn8lrjzlyfidn5075c8970gf2rvgcnyyfqgcxzx6mp6n1r";
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
