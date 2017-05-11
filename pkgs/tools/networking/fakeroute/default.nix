{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fakeroute-${version}";
  version = "0.3";

  src = fetchurl {
    url = "https://moxie.org/software/fakeroute/${name}.tar.gz";
    sha256 = "1sp342rxgm1gz4mvi5vvz1knz7kn9px9s39ii3jdjp4ks7lr5c8f";
  };

  meta = with stdenv.lib; {
    description = ''
      Makes your machine appear to be anywhere on the internet
      to any host running a (UDP) unix traceroute
    '';
    homepage = https://moxie.org/software/fakeroute/;
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
