{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs, gpgme, xz }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dar-2.5.14";

  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "1if50d3cby30id18jh7bzy9mn2jjb89lsgpynjflyaibdcb4kq7s";
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
