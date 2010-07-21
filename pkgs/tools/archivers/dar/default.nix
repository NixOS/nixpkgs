{ stdenv, fetchurl, zlib, bzip2, openssl, attr }:

stdenv.mkDerivation rec {
  name = "dar-2.3.10";
  
  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "04qzdcz97bzz414khfj82hn8s1i1ry7qxaikq8lj1069gvhc6qjn";
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
