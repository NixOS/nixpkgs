{stdenv, fetchurl, perl, zlib, bzip2}:

stdenv.mkDerivation {
  name = "dpkg-1.14.16.6";
  
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/d/dpkg/dpkg_1.14.16.6.tar.gz;
    sha256 = "1x2ajz5z6zbyv80g2b2fwylxiz7bdm71z0i98zasfjf87wkx4ryn";
  };

  configureFlags = "--without-dselect"; #  --with-admindir=/var/lib/dpkg

  buildInputs = [perl zlib bzip2];

  meta = {
    description = "The Debian package manager";
    homepage = http://wiki.debian.org/Teams/Dpkg;
  };
}
