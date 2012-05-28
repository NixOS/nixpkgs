{ stdenv, fetchurl, fuse }:
  
stdenv.mkDerivation rec {
  name = "aefs-0.4pre259-8843b7c";
  
  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.tar.bz2";
    sha256 = "167hp58hmgdavg2mqn5dx1xgq24v08n8d6psf33jhbdabzx6a6zq";
  };

  buildInputs = [ fuse ];

  meta = {
    homepage = http://www.st.ewi.tudelft.nl/~dolstra/aefs/;
    description = "A cryptographic filesystem implemented in userspace using FUSE";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
