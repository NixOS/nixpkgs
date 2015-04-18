{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "dar-2.4.17";
  
  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "0g43g6a633j6ipgwdvgwngnrnzhfwkhl2iwih1314xwbd4wir1jx";
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
