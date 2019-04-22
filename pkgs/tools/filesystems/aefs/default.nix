{ stdenv, fetchurl, fuse }:

stdenv.mkDerivation rec {
  name = "aefs-0.4pre259-8843b7c";

  src = fetchurl {
    url = "http://tarballs.nixos.org/${name}.tar.bz2";
    sha256 = "167hp58hmgdavg2mqn5dx1xgq24v08n8d6psf33jhbdabzx6a6zq";
  };

  buildInputs = [ fuse ];

  meta = with stdenv.lib; {
    homepage = https://github.com/edolstra/aefs;
    description = "A cryptographic filesystem implemented in userspace using FUSE";
    platforms = platforms.linux;
    maintainers = [ maintainers.eelco ];
    license = licenses.gpl2;
  };
}
