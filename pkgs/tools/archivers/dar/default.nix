{ stdenv, fetchurl, zlib, bzip2, openssl, attr, lzo, libgcrypt, e2fsprogs }:

stdenv.mkDerivation rec {
  name = "dar-2.4.2";
  
  src = fetchurl {
    url = "mirror://sourceforge/dar/${name}.tar.gz";
    sha256 = "0cvcy9xccg4wmvbpxyacwppapbq03m3pwjk8b3xmdn2h8lr1pziq";
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
