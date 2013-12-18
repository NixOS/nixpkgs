{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "dar-2.4.11";
  
  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "0psahvnrkljqg9507dk0vq05w8vilpm98igjrcjkqdirqcfd2py1";
  };

  buildInputs = [ zlib bzip2 openssl attr lzo libgcrypt e2fsprogs ];

  configureFlags = "--disable-dar-static";

  meta = {
    homepage = http://dar.linux.free.fr/;
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
