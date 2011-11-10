{ stdenv, fetchurl, zlib, bzip2, openssl, attr }:

stdenv.mkDerivation rec {
  name = "dar-2.3.11";
  
  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "016147f6z8k4wxym2bzgjjp54b4p82lqqwf1lvqmvgj9pbcn3wid";
  };

  buildInputs = [ zlib bzip2 openssl attr ];

  configureFlags = "--disable-dar-static";

  meta = {
    homepage = http://dar.linux.free.fr/;
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
