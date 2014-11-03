{ stdenv, fetchurl, pkgconfig, fuse, curl, expat }:
  
stdenv.mkDerivation rec {
  name = "s3backer-1.3.1";
  
  src = fetchurl {
    url = "http://s3backer.googlecode.com/files/${name}.tar.gz";
    sha256 = "1dmdvhb7mcn0fdcljpdyvfynhqrsnrg50dgl1706i8f1831lgk1r";
  };

  buildInputs = [ pkgconfig fuse curl expat ];

  meta = {
    homepage = http://code.google.com/p/s3backer/;
    description = "FUSE-based single file backing store via Amazon S3";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
