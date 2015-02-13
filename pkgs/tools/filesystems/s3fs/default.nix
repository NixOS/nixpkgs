{stdenv, fetchurl, autoconf, automake, pkgconfig, curl, openssl, libxml2, fuse}:

stdenv.mkDerivation {
  name = "sshfs-fuse-1.78";
  src = fetchurl {
    url = https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.78.tar.gz;
    sha256 = "1xcp0bqa4a2ynjn5phb1pj70wm322czhqp4qcb27d5jd545b1h1n";
  };
  preConfigure = "./autogen.sh";
  buildInputs = [ autoconf automake pkgconfig curl openssl libxml2 fuse ];
  
  meta = {
    description = "Mount an S3 bucket as filesystem through FUSE";
    license = "GPLv2";
  };
}
