{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "dar-2.4.15";
  
  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "1x694g7yhach8swkjwbkdryp74r3rh0d2lrsa8mnf0azp0mrj1ln";
  };

  buildInputs = [ zlib bzip2 openssl lzo libgcrypt ]
    ++ stdenv.lib.optional stdenv.isLinux [ attr e2fsprogs ];

  configureFlags = "--disable-dar-static";

  meta = {
    homepage = http://dar.linux.free.fr/;
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.unix;
  };
}
