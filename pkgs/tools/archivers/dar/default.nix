{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs, gpgme, xz }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.5.14";
  name = "dar-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}-bis.tar.gz";
    sha256 = "1sbd7n5mfqkwxy5rz2v8575y21j94ypwrpinizr3l2yy9pq49rx5";
  };

  buildInputs = [ zlib bzip2 openssl lzo libgcrypt gpgme xz ]
    ++ optionals stdenv.isLinux [ attr e2fsprogs ];

  configureFlags = [ "--disable-dar-static" ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  meta = {
    homepage = http://dar.linux.free.fr/;
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = [ maintainers.viric ];
    platforms = platforms.unix;
  };
}
