{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs, gpgme, xz }:

stdenv.mkDerivation rec {
  name = "dar-2.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "0myakyfgv2mhazwvbbwwncn9j7c9b4g3szs0aqlclmp01naaqmj5";
  };

  buildInputs = [ zlib bzip2 openssl lzo libgcrypt gpgme xz ]
    ++ stdenv.lib.optional stdenv.isLinux [ attr e2fsprogs ];

  configureFlags = [ "--disable-dar-static" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://dar.linux.free.fr/;
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.unix;
  };
}
