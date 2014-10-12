{stdenv, fetchurl, unzip, zlib, SDL}:

stdenv.mkDerivation {
  name = "atari800-2.2.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = mirror://sourceforge/atari800/atari800-2.2.1.tar.gz;
    sha256 = "0gkhlb3jc0rd7fcqjm41877fsqr7als3a0n552qmnjzrlcczf5yz";
  };
  rom = fetchurl {
    url = mirror://sourceforge/atari800/xf25.zip;
    sha256 = "12jbawxs04i0wm3910n7f3phsybdp8nndxc0xlsnzp8k0k8hmblq";
  };
  buildInputs = [unzip zlib SDL];
  configureFlags = "--target=sdl";
}
