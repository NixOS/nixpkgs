{ stdenv, fetchurl, automake, autoconf, subversion, fuse, apr, perl }: 

stdenv.mkDerivation {
  name = "svnfs";

  src = fetchurl {
    url = http://www.jmadden.eu/wp-content/uploads/svnfs/svnfs-0.4.tgz;
    sha256 = "1lrzjr0812lrnkkwk60bws9k1hq2iibphm0nhqyv26axdsygkfky";
  };

  buildInputs = [automake autoconf subversion fuse apr perl];

  # why is this required?
  preConfigure=''
    export LD_LIBRARY_PATH=${subversion}/lib
  '';


  NIX_CFLAGS_COMPILE="-I ${subversion}/include/subversion-1";
  NIX_LDFLAGS="-lsvn_client-1";

  meta = {
    description = "SvnFs is a filesystem written using FUSE for accessing Subversion repositories";
    homepage = http://www.jmadden.eu/index.php/svnfs/;
    license = "GPLv2";
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
