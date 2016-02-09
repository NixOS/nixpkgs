{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs, gpgme }:

stdenv.mkDerivation rec {
  name = "dar-2.5.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "09p07wil0y4g6yzb9jk1ppr6pidl5fldaqnfp0ngd5n2iz3w89js";
  };

  buildInputs = [ zlib bzip2 openssl lzo libgcrypt gpgme ]
    ++ stdenv.lib.optional stdenv.isLinux [ attr e2fsprogs ];

  configureFlags = "--disable-dar-static";

  meta = {
    homepage = http://dar.linux.free.fr/;
    description = "Disk ARchiver, allows backing up files into indexed archives";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.unix;
  };
}
