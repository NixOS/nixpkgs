{stdenv, fetchurl, zlib, bzip2, openssl}:

stdenv.mkDerivation {
  name = "dar-2.3.8";
  src = fetchurl {
    url = mirror://sourceforge/dar/dar-2.3.8.tar.gz;
    md5 = "6c0d383c22df0e1816e860153f60d746";
  };

  meta = {
	  homepage = http://dar.linux.free.fr/;
	  description = "Disk ARchiver, allows backing up files into indexed archives";
  };

  buildInputs = [zlib bzip2 openssl];
}
