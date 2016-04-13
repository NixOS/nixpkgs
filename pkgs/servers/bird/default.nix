{ stdenv, fetchurl, flex, bison, readline }:

stdenv.mkDerivation rec {
  name = "bird-1.5.0";

  src = fetchurl {
    url = "ftp://bird.network.cz/pub/bird/${name}.tar.gz";
    sha256 = "0pbvq6rx4ww46vcdslpiplb5fwq3mqma83434q38kx959qjw9mbr";
  };

  buildInputs = [ flex bison readline ];

  patches = [
    ./dont-create-sysconfdir.patch
  ];

  configureFlags = [
    "--localstatedir /var"
  ];

  meta = {
    description = "BIRD Internet Routing Daemon";
    homepage = http://bird.network.cz;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms  = stdenv.lib.platforms.linux;
  };
}
